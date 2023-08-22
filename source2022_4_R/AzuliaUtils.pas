{=================================================
      FindRecursive

      You need this function in your main unit    SFOpenError

      Function LogFiles( Const path: String; Const SRec: TSearchRec ): Boolean;
      Begin
           Listbox1.Items.Add( path+SRec.Name );
           Result := True;
      End;
=================================================}

unit AzuliaUtils;

interface

uses Windows, Forms, Classes, ShlObj, Registry, Messages, SysUtils, Graphics,
  StdCtrls, FileCtrl, INIFiles, ShellAPI, Consts, MMSystem, Dialogs, extctrls,
  imagehlp, comctrls, grids, JPEG, Wininet;

type
  charSet = set of char;

type
  IShellLink = class { sl }
    function GetPath(pszFile: LPSTR; cchMaxPath: integer; var pfd: TWin32FindData; fFlags: DWORD): HResult; virtual; stdcall; abstract;
    function GetIDList(var ppidl: PITEMIDLIST): HResult; virtual; stdcall; abstract;
    function SetIDList(pidl: PITEMIDLIST): HResult; virtual; stdcall; abstract;
    function GetDescription(pszName: LPSTR; cchMaxName: integer): HResult; virtual; stdcall; abstract;
    function SetDescription(pszName: LPSTR): HResult; virtual; stdcall; abstract;
    function GetWorkingDirectory(pszDir: LPSTR; cchMaxPath: integer): HResult; virtual; stdcall; abstract;
    function SetWorkingDirectory(pszDir: LPSTR): HResult; virtual; stdcall; abstract;
    function GetArguments(pszArgs: LPSTR; cchMaxPath: integer): HResult; virtual; stdcall; abstract;
    function SetArguments(pszArgs: LPSTR): HResult; virtual; stdcall; abstract;
    function GetHotkey(var pwHotkey: word): HResult; virtual; stdcall; abstract;
    function SetHotkey(wHotkey: word): HResult; virtual; stdcall; abstract;
    function GetShowCmd(var piShowCmd: integer): HResult; virtual; stdcall; abstract;
    function SetShowCmd(iShowCmd: integer): HResult; virtual; stdcall; abstract;
    function GetIconLocation(pszIconPath: LPSTR; cchIconPath: integer; var piIcon: integer): HResult; virtual; stdcall; abstract;
    function SetIconLocation(pszIconPath: LPSTR; iIcon: integer): HResult; virtual; stdcall; abstract;
    function SetRelativePath(pszPathRel: LPSTR; dwReserved: DWORD): HResult; virtual; stdcall; abstract;
    function Resolve(Wnd: HWND; fFlags: DWORD): HResult; virtual; stdcall; abstract;
    function SetPath(pszFile: LPSTR): HResult; virtual; stdcall; abstract;
  end;


type
  TBrowseForFolderDialog = class
  private
    bi: TBROWSEINFO;
    str: array[0..MAX_PATH] of Char;
    pIDListItem: PItemIDList;
    pStr: PChar;
    procedure SetTitle(Title: string);
    function GetTitle: string;
    function GetPath: string;
  public
    property Title: string read GetTitle write SetTitle;
    function Execute: Boolean;
    property Path: string read GetPath;
  end;

type
  TSystemRegistry = class
  private
    SystemReg: TRegistry;
  public
    function GetStringFromRegistry(Root: integer; Key, Value: string): string;
    function SaveStringToRegistry(Root: integer; Key, Value, Name: string): bool;
    procedure ToggleBinaryValue(RootKey: integer; Path, Key: string);
    procedure DeleteValueInRegistry(RootKey: integer; Path, Name: string);
    procedure RenameValueInRegistry(RootKey: integer; Path, OldName, NewName: string);
  end;

type
  TAzuliaStrings = class
  public
    function NPos(C: Char; S: string; N: Byte): Byte;
    function IntToRoman(Value: Longint): string;
    function RomanToInt(const S: string): Longint;
    function GetDirFromStr(DirectoryString: string; IndexFromRight: integer): string;
    function RemoveChars(InputString: string; CharToRemove: Char): string;
    function GetStringFromGarbage(InputString: string; Index: integer): string;
    function SplitupWithGarbage(InputString: string; CommonSplitter: char): string;
    function GetCount(Character: char; InputString: string): integer;
    function RemoveTrailingChars(StringToRemoveFrom: string; Trailer: char): string;
  end;

  TLogFunct = function(const path: string; const SRec: TSearchRec): Boolean of object;


type
  TAzuliaFiles = class
  public

    procedure FindRecursive(const path: string; const mask: string; LogFunction: TLogFunct; Re_curse: Boolean);
    procedure SearchFileExt(const Dir, Ext: string; Files: TStrings);

    function GetFileSize(const FileName: string): LongInt;
    function GetKBFileSize(FileSize: integer): string;

    function LongToShortFilename(LongFilename: string): string;
    function ShortToLongFilename(LongFilename: string): string;

    procedure AppendDataToFilename(Filename, Data: string);
    procedure SaveDataToFilename(Filename, Data: string);

    procedure CopyFile(const FileName, DestName: string);
    procedure MoveFile(const FileName, DestName: string);
    function HasAttr(const FileName: string; Attr: Word): Boolean;
    function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;

    function GetWindowsDir: string;
    function GetTempDir: string;
    //function WriteINIString(Section, Ident, DefaultString, Filename: string): string;
    function GetINIString(Section, Ident, DefaultString, Filename: string): string;
  end;

type
  TAzuliaSpeaker = class(TComponent)
  private
    procedure NoSound;
    procedure Sound(Freq: Word);
    procedure SetPort(address, value: Word);
    function GetPort(address: Word): Word;
  protected
  public
    procedure Delay(MSecs: Integer);
    procedure Play(Freq: Word; MSecs: Integer);
    procedure Stop;
  published
  end;

type
  TAzuliaDisk = class(TComponent)
  private
    FDiskLabel: string;
    FDiskSerial: string;
    FFileSystem: string;
    FDriveType: integer;
    FDriveFlags: DWord;

    procedure ExamineDrive(Drive: char);
  public
    function GetDiskLabel(Drive: char): string;
    function GetDiskSerial(Drive: char): string;
    function GetDiskFileSystem(Drive: char): string;
    function GetDiskType(Drive: char): integer;
    function GetDiskFlags(Drive: char): integer;
    procedure ChangeDiskLabel(Drive: char; NewLabel: string);

  end;

type
  TAzuliaHTML = class(TComponent)
  public
    function HeadTop(Title: string): string;
    function HeadClose: string;
    function BodyTop(LeftMargin, RightMargin: Integer; TextColor, LinkColor, VisitedLinkColor, ActiveLinkColor, BackgroundColor, BackgroundImage: string; FixedBackground: bool; Extra: string): string; //<BODY LEFTMARGIN=12 TOPMARGIN=12 TEXT=AQUA LINK=BLACK VLINK=BLUE ALINK=FUCHSIA BGCOLOR=GREEN BACKGROUND="image.jpg" BGPROPERTIES=FIXED>
    function BodyClose: string;
    function ConvertDOSPathToHTML(WindowsPath: string): string;
    function ConvertHTMLPathToDOS(WindowsPath: string): string;
  end;

Type
  GrabType = (GTSCREEN,GTWINDOW,GTCLIENT);


  EInvalidDest = class(EStreamError);
  EFCantMove = class(EStreamError);

function BoolToStr(value: boolean): string;
procedure ChangeWallpaper(FName: string; IsTiled, IsStretch: Boolean);
function DoIExist(WndTitle: string): Boolean;
procedure Alert(Text: string);
procedure TileImage(SourceImage, DestImage: TImage);
function IncChar(iX: Char): Char;
function DecChar(iX: Char): Char;
procedure SaveForm(F: TForm; Filename: string);
procedure LoadForm(F: TForm; Filename: string);
function ToggleBool(totoggle: bool): bool;
function removeTrailingChars(const s: string; chars: charSet): string;
function removeLeadChars(const s: string; chars: charSet): string;
function removeChars(const s: string; chars: char): string;
procedure Delay(MSecs: Integer);
function SHBrowseDialog(title: string; Handle: integer): string;
procedure CallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM)stdcall;
procedure registerfiletype(Extention, REGDesc, UserDesc, Icon, Appl: string);
procedure RemoveFileType(Extention, RegDesc: string);
procedure GetFunctionNamesFromDLL(DLLName: string; List: TStrings);
procedure SaveListViewToFile(AListView: TListView; sFileName: string); 
procedure LoadListViewToFile(AListView: TListView; sFileName: string);
procedure LoadCSV(Filename: string; sg: TStringGrid);
function JPEGDimensions(Filename : string; var X, Y : Word) : boolean;

procedure ResizeImage(FileName: string; MaxWidth: Integer);
function SaveJPEGPictureFile(Bitmap: TBitmap; FilePath, FileName: string; Quality: Integer): Boolean;
function LoadJPEGPictureFile(Bitmap: TBitmap; FilePath, FileName: string): Boolean;
procedure SmoothResize(Src, Dst: TBitmap);
function MsecToStr(Milli: Cardinal): string;
procedure DirToStrings(APath : string; AStrings : TStrings; WithExt, WithPath: boolean ); //APath = c:\windows\*.exe
procedure SetWallPaper( ImageFileName: string; IsTiled: boolean );
function GetFileSize( FileName: string ): int64;
function GetExeByExtension(sExt : string) : string;
function RefreshScreenIcons : Boolean;
function IndexToColor(AIndex: integer): TColor;
function ColorToIndex(AColor: TColor): integer;
function TitleCase(Text2:string):string;
function ToggleCase(Text2:string):string;
function SentenceCase(Text2:string):string;
procedure GrabScreen(bm: TBitMap; gt : GrabType);
procedure SaveStringGrid(StringGrid: TStringGrid; FileName: String);
procedure LoadStringGrid(StringGrid: TStringGrid; FileName: String);
function GetInetFile(const fileURL, FileName: String): boolean;
procedure RunOnStartup(sProgTitle, sCmdLine: string; bRunOnce: boolean );
procedure RemoveOnStartup(sProgTitle: string);

var
  AtomText: array[0..31] of Char;
  DriveType: array[0..10] of string;
  Alphabet: array[1..26] of Char;

const
  SInvalidDest = 'Destination %s does not exist';
  SFCantMove = 'Cannot move file %s';
  SFOpenError = 'File "%s" does not exist!';
  Msg2 = '"%s" is not a ListView file!';
  sr_WindowMetrics='Control Panel\Desktop\WindowMetrics\';
  sr_ShellIconSize='Shell Icon Size';
  Colors: array[1..42 {sic!}] of TColor = (clBlack, clMaroon, clGreen, clOlive,
    clNavy, clPurple, clTeal, clDkGray, clLtGray, clRed, clLime,
    clYellow, clBlue, clFuchsia, clAqua, clWhite, clScrollBar,
    clBackground, clActiveCaption, clInactiveCaption, clMenu, clWindow,
    clWindowFrame, clMenuText, clWindowText, clCaptionText,
    clActiveBorder, clInactiveBorder, clAppWorkSpace, clHighlight,
    clHighlightText, clBtnFace, clBtnShadow, clGrayText, clBtnText,
    clInactiveCaptionText, clBtnHighlight, cl3DDkShadow, cl3DLight,
    clInfoText, clInfoBk, clNone);
   
implementation


procedure RunOnStartup(sProgTitle, sCmdLine: string; bRunOnce: boolean );
var
  sKey : string;
  reg  : TRegIniFile;
begin
  if( bRunOnce )then
    sKey := 'Once'
  else
    sKey := '';

  reg := TRegIniFile.Create( '' );
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.WriteString('Software\Microsoft\Windows\CurrentVersion\Run' + sKey + #0, sProgTitle, sCmdLine );
  reg.Free;
end;

procedure RemoveOnStartup(sProgTitle: string);
var
  sKey : string;
  reg  : TRegIniFile;
begin
  reg := TRegIniFile.Create( '' );
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Run', sProgTitle);
  reg.Free;
end;

function GetInetFile(const fileURL, FileName: String): boolean;
const BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: File;
  sAppName: string;
begin
 Result:=False;
 sAppName := ExtractFileName(Application.ExeName);
 hSession := InternetOpen(PChar(sAppName),
                INTERNET_OPEN_TYPE_PRECONFIG,
               nil, nil, 0);
 try
  hURL := InternetOpenURL(hSession,
            PChar(fileURL),
            nil,0,0,0);
  try
   AssignFile(f, FileName);
   Rewrite(f,1);
   repeat
    InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
    BlockWrite(f, Buffer, BufferLen)
   until BufferLen = 0;
   CloseFile(f);
   Result:=True;
  finally
   InternetCloseHandle(hURL)
  end
 finally
  InternetCloseHandle(hSession)
 end
end;




procedure GrabScreen(bm: TBitMap; gt : GrabType);
var
  DestRect, SourceRect: TRect;
  h: THandle;
  hdcSrc : THandle;
  pt : TPoint;
begin
  case(gt) of
    GTWINDOW, GTCLIENT : h := GetForeGroundWindow;
    GTSCREEN : h := GetDesktopWindow;
  else h := 0;
  end;
  if h <> 0 then
  begin
    try
      if gt = GTCLIENT then
      begin
        hdcSrc := GetDC(h); // use this for ClientRect
        Windows.GetClientRect(h,SourceRect);
      end
      else
      begin
          hdcSrc := GetWindowDC(h);
          GetWindowRect(h, SourceRect);
      end;
        bm.Width  := SourceRect.Right - SourceRect.Left;
        bm.Height := SourceRect.Bottom - SourceRect.Top;
        DestRect := Rect(0, 0, SourceRect.Right - SourceRect.Left, SourceRect.Bottom - SourceRect.Top);
          StretchBlt(bm.Canvas.Handle, 0, 0, bm.Width,
            bm.Height, hdcSrc,
            0,0,SourceRect.Right - SourceRect.Left,
            SourceRect.Bottom - SourceRect.Top,
            SRCCOPY);
        if gt = GTCLIENT then
        begin
           pt.X :=SourceRect.Left;
           pt.Y :=SourceRect.Top;
           // call Windows.ClientToScreen() to translate X and Y
           Windows.ClientToScreen(h, pt);
           //DrawCursor(bm,pt.X, pt.Y);
        end
          else
          //DrawCursor(bm,SourceRect.Left, SourceRect.Top);
    finally
      ReleaseDC(0, hdcSrc);
    end;
  end;
end;


function SentenceCase(Text2:string):string;
var i:integer;
    t: string;
begin
   for i:=2 to Length(Text2) do
   begin
     if (Text2[i-1] in ['.','!','?']) then
     begin
       Text2[i]:=UpCase(Text2[i]);
     end
     else
     begin
       t := LowerCase(Text2[i]);
       Text2[i]:=t[1];
     end;
   end;
   Result:=Text2;
end;

function ToggleCase(Text2:string):string;
var i:integer;
    t: string;
begin
   for i:=2 to length(Text2) do
   begin
     if (Text2[i] in ['A'..'Z']) then
     begin
       t := LowerCase(Text2[i]);
       Text2[i]:= t[1];
     end
     else
     if (Text2[i] in ['a'..'z']) then
     begin
       Text2[i]:=UpCase(Text2[i])
     end;
   end;
   Result:=Text2;
end;

function TitleCase(Text2:string):string;
var i:integer;
    t: string;
begin
   for i:=2 to length(Text2) do
   begin
     if (not(Text2[i-1] in ['A'..'Z','a'..'z'])) then
      Text2[i]:=UpCase(Text2[i])
     else
     begin
       t := LowerCase(Text2[i]);
       Text2[i] := t[1];
     end;
   end;
   Result:=Text2;
end;

function ColorToIndex(AColor: TColor): integer;
var
  i: integer;
begin
  Result := 0;
  for i := Low(Colors) to High(Colors) do
    if Colors[i] = AColor then begin
      Result := i - 1;
      break;
    end;
end;

function IndexToColor(AIndex: integer): TColor;
begin
  Result := Colors[AIndex + 1];
end;

function RefreshScreenIcons : Boolean;
const
  KEY_TYPE = HKEY_CURRENT_USER;
  KEY_NAME = 'Control Panel\Desktop\WindowMetrics';
  KEY_VALUE = 'Shell Icon Size';
var
  Reg: TRegistry;
  strDataRet, strDataRet2: string;

 procedure BroadcastChanges;
 var
   success: DWORD;
 begin
   SendMessageTimeout(HWND_BROADCAST,
                      WM_SETTINGCHANGE,
                      SPI_SETNONCLIENTMETRICS,
                      0,
                      SMTO_ABORTIFHUNG,
                      10000,
                      success);
 end;


begin
  Result := False;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := KEY_TYPE;
    // 1. open HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics
    if Reg.OpenKey(KEY_NAME, False) then
    begin
      // 2. Get the value for that key
      strDataRet := Reg.ReadString(KEY_VALUE);
      Reg.CloseKey;
      if strDataRet <> '' then
      begin
        // 3. Convert sDataRet to a number and subtract 1,
        //    convert back to a string, and write it to the registry
        strDataRet2 := IntToStr(StrToInt(strDataRet) - 1);
        if Reg.OpenKey(KEY_NAME, False) then
        begin
          Reg.WriteString(KEY_VALUE, strDataRet2);
          Reg.CloseKey;
          // 4. because the registry was changed, broadcast
          //    the fact passing SPI_SETNONCLIENTMETRICS,
          //    with a timeout of 10000 milliseconds (10 seconds)
          BroadcastChanges;
          // 5. the desktop will have refreshed with the
          //    new (shrunken) icon size. Now restore things
          //    back to the correct settings by again writing
          //    to the registry and posing another message.
          if Reg.OpenKey(KEY_NAME, False) then
          begin
            Reg.WriteString(KEY_VALUE, strDataRet);
            Reg.CloseKey;
            // 6.  broadcast the change again
            BroadcastChanges;
            Result := True;
          end;
        end;
      end;
    end;
  finally
    Reg.Free;
  end;
end;






function GetExeByExtension(sExt : string) : string;
var
   sExtDesc:string;
begin
   with TRegistry.Create do
   begin
     try
       RootKey:=HKEY_CLASSES_ROOT;
       if OpenKeyReadOnly(sExt) then
       begin
         sExtDesc:=ReadString('') ;
         CloseKey;
       end;
       if sExtDesc <>'' then
       begin
         if OpenKeyReadOnly(sExtDesc + '\Shell\Open\Command') then
         begin
           Result:= ReadString('') ;
         end
       end;
     finally
       Free;
     end;
   end;

   if Result <> '' then
   begin
     if Result[1] = '"' then
     begin
       Result:=Copy(Result,2,-1 + Pos('"',Copy(Result,2,MaxINt))) ;
     end
   end;
end;

function BoolToStr(value: boolean): string;
begin
  if value = false then result := 'False';
  if value = true then result := 'True';
end;

function GetFileSize( FileName:string ): int64;
  var
    fh: integer;
    fi: TByHandleFileInformation;
  begin
  result := 0;
  fh := fileopen( FileName, fmOpenRead );
    try
    if GetFileInformationByHandle( fh, fi ) then
      begin
      result := fi.nFileSizeHigh;
      result := result shr 32 + fi.nFileSizeLow;
      end;
    finally
    fileclose( fh );
    end;
  end;

procedure SetWallPaper( ImageFileName: string; IsTiled: boolean );
  begin
  SystemParametersInfo( SPI_SETDESKWALLPAPER, 0, PChar( imagefilename ), SPIF_UPDATEINIFILE );
  end;


procedure DirToStrings(APath : string; AStrings : TStrings; WithExt, WithPath: boolean ); //APath = c:\windows\*.exe
	var
		Found, p : integer;
		SearchRec : TSearchRec;
    fn: string;
	begin
	AStrings.Clear;
	Found := FindFirst(APath, faAnyFile, SearchRec);
	while Found = 0 do
		begin
		p := Pos('.',SearchRec.Name);
		if p > 1 then //esclude . e .. e i file con nomi piu' lunghi di 10
			begin
      fn := SearchRec.Name;
      if not WithExt then
        fn := ChangeFileExt( fn, '' );
      if WithPath then
        fn := ExtractFilePath( APath ) + fn;
			AStrings.Add( fn );
			end;
		Found := FindNext( SearchRec );
		end;
	FindClose( SearchRec );
	end;


function MsecToStr(Milli: Cardinal): string;
  var
    h, m, s: Cardinal;
  begin
  h := Milli div 3600000;
  milli := milli mod 3600000;
  m := Milli div 60000;
  milli := milli mod 60000;
  s := Milli div 1000;
  milli := milli mod 1000;
  Result := Format( '%2d:%.2d:%.2d.%.3d', [ h, m, s, milli ] );
  end;

procedure GetFunctionNamesFromDLL(DLLName: string; List: TStrings);
type chararr = array[0..$FFFFFF] of char;
var h: THandle;
  i, fc: integer;
  st: string;
  arr: pointer;
  ImageDebugInformation: PImageDebugInformation;
begin
  List.Clear;
  DLLName := ExpandFileName(DLLName);
  if not FileExists(DLLName) then
    Exit;
  h := CreateFile(PChar(DLLName), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if h = -1 then
    Exit;
  ImageDebugInformation := MapDebugInformation(h, PChar(DLLName), nil, 0);
  if ImageDebugInformation = nil then
    Exit;
  arr := ImageDebugInformation^.ExportedNames;
  fc := 0;
  for i := 0 to ImageDebugInformation^.ExportedNamesSize - 1 do
  begin
    if chararr(arr^)[i] = #0 then
    begin
      st := PChar(@chararr(arr^)[fc]);
      if length(st) > 0 then
        List.Add(st);
      if (i > 0) and (chararr(arr^)[i - 1] = #0) then
        Break;
      fc := i + 1;
    end;
  end;
  UnmapDebugInformation(ImageDebugInformation);
  CloseHandle(h);
end;

procedure registerfiletype(Extention, REGDesc, UserDesc, Icon, Appl: string);
var myreg: treginifile;
  ft, key, desc, prg: string;
  ct: integer;
begin
  ft := Extention;
  key := REGDesc;
  desc := UserDesc;
  prg := Appl;
  // make a correct file-extension
  ct := pos('.', ft);
  while ct > 0 do begin
    delete(ft, ct, 1);
    ct := pos('.', ft);
  end;
  if (ft = '') or (prg = '') then exit; //not a valid file-ext or ass. app
  ft := '.' + ft;
  try
    myreg := treginifile.create('');
    myreg.rootkey := hkey_classes_root; // where all file-types are described
    if key = '' then key := copy(ft, 2, maxint) + '_auto_file'; // if no key-name is given,
    // create one
    RemoveFileType(Extention, RegDesc);
    myreg.writestring(ft, '', key); // set a pointer to the description-key
    myreg.writestring(key, '', desc); // write the description
    if icon <> '' then
      myreg.writestring(key + '\DefaultIcon', '', icon); // write the def-icon if given
    myreg.writestring(key + '\shell\open\command', '', prg + ' %1'); //association
  finally
    myreg.free;
  end;
    SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil) ;

  //showmessage('File-Type ' + ft + ' associated with'#13#10 +
  //  prg + #13#10);
end;

procedure RemoveFileType(Extention, RegDesc: string);
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_CLASSES_ROOT;
    OpenKey(Extention, FALSE);
    if ReadString('') = RegDesc then
    begin
      CloseKey;
      DeleteKey(Extention);
    end;
    Free;
  end;
end;


procedure Delay(MSecs: Integer);
var
  FirstTickCount: LongInt;
begin
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages; {allowing access to other controls, etc.}
  until ((GetTickCount - FirstTickCount) >= LongInt(MSecs));
end;


function removeLeadChars(const s: string; chars: charSet): string;
var
  i: integer;
begin
  i := 1;
  if not (Length(s) = 0) then
    while (s[i] in chars) do
      inc(i);
  Result := Copy(s, i, MAXINT);
end;

function removeTrailingChars(const s: string; chars: charSet): string;
var
  i: integer;
begin
  i := length(s);
  if not (Length(s) = 0) then
    while (s[i] in chars) and (i <> 0) do
      dec(i);
  Result := copy(s, 1, i);
end;


function removeChars(const s: string; chars: char): string;
var n: string;
begin
  n := s;
  //if not (Length(n) = 0) then
  while (pos(chars, n) > 0) do
    Delete(n, pos(chars, n), 1);

  Result := n;
end;




procedure LoadForm(F: TForm; Filename: string);
var
  fs: TFileStream;
  i: integer;
begin
  if FileExists(Filename) then
  begin
    fs := TFileStream.Create(Filename, fmOpenRead);
    try
      for i := 0 to F.ComponentCount - 1 do
        fs.ReadComponent(F.Components[i]);
    finally
      fs.Free;
    end;
  end;
end;

procedure SaveForm(F: TForm; Filename: string);
var
  fs: TFileStream;
  i: integer;
begin
  fs := TFileStream.Create(Filename, fmCreate);
  try
    for i := 0 to F.ComponentCount - 1 do
      fs.WriteComponent(F.Components[i]);
  finally
    fs.Free;
  end;
end;


function IncChar(iX: Char): Char;
var a, b: integer;
begin
  for a := 1 to 26 do
    if LowerCase(Alphabet[a]) = LowerCase(ix) then
    begin
      if a = 26 then b := 1 else b := a + 1;
      Result := LowerCase(Alphabet[b])[1];
    end;
end;

function DecChar(iX: Char): Char;
var a, b: integer;
begin
  for a := 1 to 26 do
    if LowerCase(Alphabet[a]) = LowerCase(ix) then
    begin
      if a = 1 then b := 26 else b := a - 1;
      Result := LowerCase(Alphabet[b])[1];
    end;
end;

procedure TileImage(SourceImage, DestImage: TImage);
var
  XCnt, YCnt, X, Y: Integer;
  BevelSize, SaveIndex: Integer;
  Rect: TRect;
begin

  if (SourceImage.Picture.Graphic <> nil) and (SourceImage.Width > 0) and
    (SourceImage.Height > 0) then
  begin
    Rect := DestImage.ClientRect;
    //BevelSize := BorderWidth;
    //if BevelOuter <> bvNone then Inc(BevelSize, BevelWidth);
    //if BevelInner <> bvNone then Inc(BevelSize, BevelWidth);
    //InflateRect(Rect, -BevelSize, -BevelSize);
    SaveIndex := SaveDC(DestImage.Canvas.Handle);
    try
      IntersectClipRect(DestImage.Canvas.Handle, Rect.Left, Rect.Top,
        Rect.Right - Rect.Left + 1,
        Rect.Bottom - Rect.Top + 1);
      XCnt := DestImage.ClientWidth div SourceImage.Width;
      YCnt := DestImage.ClientHeight div SourceImage.Height;
      for X := 0 to XCnt do
        for Y := 0 to YCnt do
          DestImage.Canvas.Draw(Rect.Left + X * SourceImage.Width,
            Rect.Top + Y * SourceImage.Height, SourceImage.Picture.Graphic);
    finally
      RestoreDC(DestImage.Canvas.Handle, SaveIndex);
    end;
  end;
end;

procedure Alert(Text: string);
begin
  MessageDlg(Text, mtInformation, [mbOk], 0)
end;

procedure LoadStringGrid(StringGrid: TStringGrid; FileName: String);
var
  F: TextFile;
  Tmp, x, y: Integer;
  TmpStr: string;
begin
  AssignFile(F, FileName);
  Reset(F);
  Readln(F, Tmp);
  StringGrid.ColCount:=Tmp;
  Readln(F, Tmp);
  StringGrid.RowCount:=Tmp;
  for x:=0 to StringGrid.ColCount-1 do
    for y:=0 to StringGrid.RowCount-1 do
    begin
      Readln(F, TmpStr);
      StringGrid.Cells[x,y]:=TmpStr;
    end;
  CloseFile(F);
end;

procedure SaveStringGrid(StringGrid: TStringGrid; FileName: String);
var
  F: TextFile;
  x, y: Integer;
begin
  AssignFile(F, FileName);
  Rewrite(F);
  Writeln(F, StringGrid.ColCount);
  Writeln(F, StringGrid.RowCount);
  for x:=0 to StringGrid.ColCount-1 do
    for y:=0 to StringGrid.RowCount-1 do
      Writeln(F, StringGrid.Cells[x,y]);
  CloseFile(F);
end;

procedure LoadCSV(Filename: string; sg: TStringGrid);
var
   i, j, Position, count, edt1: integer;
   temp, tempField : string;
   FieldDel: char;
   Data: TStringList;
begin
  Data := TStringList.Create;
  FieldDel := ',';
  Data.LoadFromFile(Filename);
  temp :=  Data[1];
  count := 0;
  for i:= 1 to length(temp) do
    if copy(temp,i,1) =  FieldDel then
      inc(count);
  edt1 := count+1;
  sg.ColCount := 30;
  sg.RowCount := Data.Count +1;
  sg.FixedCols := 0;
  for i := 0 to Data.Count - 1 do
    begin;
      temp :=  Data[i];
      if copy(temp,length(temp),1) <> FieldDel then
        temp := temp + FieldDel;
      while Pos('"', temp) > 0 do
        begin
          Delete(temp,Pos('"', temp),1);
        end;
      for j := 1 to edt1 do
      begin
        Position := Pos(FieldDel,temp);
        tempField := copy(temp,0,Position-1);
        sg.Cells[j-1,i+1] := tempField;
        Delete(temp,1,length(tempField)+1);
      end;
    end;
    Data.Free;
end;



{=================================================
      BrowseForFolder Class
=================================================}

procedure TBrowseForFolderDialog.SetTitle(Title: string);
begin
  bi.lpszTitle := PChar(Title);
end;

function TBrowseForFolderDialog.GetTitle: string;
begin
  Result := bi.lpszTitle;
end;

function TBrowseForFolderDialog.GetPath: string;
begin
  Result := pStr;
end;

function TBrowseForFolderDialog.Execute: Boolean;
begin
  bi.hwndOwner := GetActiveWindow;
  bi.pidlRoot := nil;
  bi.pszDisplayName := @str;
  bi.ulFlags := bif_RETURNONLYFSDIRS;
  bi.lpfn := nil;
  pIDListItem := SHBrowseForFolder(bi);
  if pIDListItem <> nil then
  begin
    pStr := @Str;
    SHGetPathFromIDList(pIDListItem, pStr);
    Result := True;
  end
  else
    Result := False;
end;






function SHBrowseDialog(title: string; Handle: integer): string;
var
  InfoType: Byte;
  BI: TBrowseInfo;
  S: PChar;
  Image: Integer;
  PIDL: PItemIDList;
  Path: array[0..MAX_PATH - 1] of WideChar;
  ResPIDL: PItemIDList;
begin
  // Add ShlObj to uses clause
  SHGetSpecialFolderLocation(Handle, CSIDL_PROGRAMS, PIDL);
  S := StrAlloc(128);
  with BI do
  begin
    hwndOwner := Handle;
    pszDisplayName := S;
    lpszTitle := @Title;
    ulFlags := BIF_STATUSTEXT;
    pidlRoot := PIDL;
    lpfn := @CallBack;
    iImage := Image;
  end;
  ResPIDL := SHBrowseForFolder(BI);
  SHGetPathFromIDList(ResPIDL, @Path[0]);
  Result := StrPas(@Path[0]);
  StrDispose(S);
end;

procedure CallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM); stdcall;
var S: string;
begin
  S := 'Choose folder for installation';
  SendMessage(Wnd, BFFM_SETSTATUSTEXT, 0, LongInt(@S[1]));
end;

{=================================================
                  Registry Class
=================================================}

function TSystemRegistry.GetStringFromRegistry(Root: integer; Key, Value: string): string;
var SystemReg2: TRegistry;
begin
  SystemReg2 := TRegistry.Create;
  SystemReg2.RootKey := Root;
  with SystemReg2 do
  begin
    if OpenKey(Key, FALSE) then
      Result := ReadString(Value)
    else
      Result := '0';
  end;
  SystemReg2.CloseKey;
  SystemReg2.Free;
end;

function TSystemRegistry.SaveStringToRegistry(Root: integer; Key, Value, Name: string): bool;
var SystemReg2: TRegistry;
begin
  SystemReg2 := Tregistry.Create;
  SystemReg2.RootKey := Root;
  with SystemReg2 do
  begin
    if OpenKey(Key, TRUE) then
    begin
      WriteString(Name, Value);
      Result := TRUE;
    end
    else
      Result := FALSE;
  end;
  SystemReg2.CloseKey;
  SystemReg2.Free;
end;

procedure TSystemRegistry.ToggleBinaryValue(RootKey: integer; Path, Key: string);
begin
  SystemReg := TRegistry.Create;
  SystemReg.RootKey := RootKey;
  if SystemReg.OpenKey(Path, FALSE) then
  begin
    if SystemReg.ReadBool(Key) = TRUE then
      SystemReg.WriteBool(Key, FALSE)
    else
      SystemReg.WriteBool(Key, TRUE);
  end;
end;

procedure TSystemRegistry.DeleteValueInRegistry(RootKey: integer; Path, Name: string);
var SystemReg2: TRegistry;
begin
  SystemReg2 := TRegistry.Create;
  SystemReg2.RootKey := RootKey;
  if SystemReg2.OpenKey(Path, FALSE) then
  begin
    SystemReg2.DeleteValue(Name);
  end;
  SystemReg2.CloseKey;
  SystemReg2.Free;
end;

procedure TSystemRegistry.RenameValueInRegistry(RootKey: integer; Path, OldName, NewName: string);
begin
  SystemReg := TRegistry.Create;
  SystemReg.RootKey := RootKey;
  if SystemReg.OpenKey(Path, FALSE) then
  begin
    SystemReg.RenameValue(OldName, NewName);
  end;
  SystemReg.CloseKey;
  SystemReg.Free;
end;

{=================================================
      WallpaperChanger
=================================================}

procedure ChangeWallpaper(FName: string; IsTiled, IsStretch: Boolean);
type
  FRName = array[0..255] of Char;
var
  PasFileName: string;
  Ptr: ^FRName;
  Reg: TRegistry;
begin
  New(Ptr);
  Reg := TRegistry.Create;
  Reg.OpenKey('\Control Panel\desktop', FALSE);
  if IsTiled then
  begin
    Reg.WriteString('TileWallPaper', '1');
    Reg.WriteString('WallpaperStyle', '0');
  end
  else
  begin
    Reg.WriteString('TileWallPaper', '0');
    Reg.WriteString('WallpaperStyle', '0');
  end;
  if IsStretch then
  begin
    Reg.WriteString('TileWallPaper', '0');
    Reg.WriteString('WallpaperStyle', '2');
  end;
  PasFileName := FName;
  StrPCopy(Ptr^, PasFileName);
  SystemParametersInfo(SPI_SetDeskWallPaper, 1, Ptr, SPIF_UPDATEINIFILE);
  Reg.OpenKey('\Control Panel\desktop', FALSE);
  Reg.WriteString('Wallpaper', FName);
  DisPose(Ptr);
  Reg.Free;
end;







{=================================================
                  Strings
=================================================}

function IsNumber(n: string): Boolean;
begin
  //
end;

function TAzuliaStrings.NPos(C: Char; S: string; N: Byte): Byte;
var
  I, P, K: Integer;
begin
  Result := 0;
  K := 0;
  for I := 1 to N do begin
    P := Pos(C, S);
    Inc(K, P);
    if (I = N) and (P > 0) then begin
      Result := K;
      Exit;
    end;
    if P > 0 then Delete(S, 1, P)
    else Exit;
  end;
end;

function TAzuliaStrings.RomanToInt(const S: string): Longint;
const
  RomanChars = ['C', 'D', 'I', 'L', 'M', 'V', 'X'];
  RomanValues: array['C'..'X'] of Word =
    (100, 500, 0, 0, 0, 0, 1, 0, 0, 50, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 10);
var
  Index, Next: Char;
  I: Integer;
  Negative: Boolean;
begin
  Result := 0;
  I := 0;
  Negative := (Length(S) > 0) and (S[1] = '-');
  if Negative then Inc(I);
  while (I < Length(S)) do begin
    Inc(I);
    Index := UpCase(S[I]);
    if Index in RomanChars then begin
      if Succ(I) <= Length(S) then Next := UpCase(S[I + 1])
      else Next := #0;
      if (Next in RomanChars) and (RomanValues[Index] < RomanValues[Next]) then
      begin
        Inc(Result, RomanValues[Next]);
        Dec(Result, RomanValues[Index]);
        Inc(I);
      end
      else Inc(Result, RomanValues[Index]);
    end
    else begin
      Result := 0;
      Exit;
    end;
  end;
  if Negative then Result := -Result;
end;

function TAzuliaStrings.IntToRoman(Value: Longint): string;
label
  A500, A400, A100, A90, A50, A40, A10, A9, A5, A4, A1;
begin
  Result := '';
{$IFNDEF WIN32}
  if (Value > MaxInt * 2) then Exit;
{$ENDIF}
  while Value >= 1000 do begin
    Dec(Value, 1000); Result := Result + 'M';
  end;
  if Value < 900 then goto A500
  else begin
    Dec(Value, 900); Result := Result + 'CM';
  end;
  goto A90;
  A400:
    if Value < 400 then goto A100
  else begin
    Dec(Value, 400); Result := Result + 'CD';
  end;
  goto A90;
  A500:
    if Value < 500 then goto A400
  else begin
    Dec(Value, 500); Result := Result + 'D';
  end;
  A100:
    while Value >= 100 do begin
    Dec(Value, 100); Result := Result + 'C';
  end;
  A90:
    if Value < 90 then goto A50
  else begin
    Dec(Value, 90); Result := Result + 'XC';
  end;
  goto A9;
  A40:
    if Value < 40 then goto A10
  else begin
    Dec(Value, 40); Result := Result + 'XL';
  end;
  goto A9;
  A50:
    if Value < 50 then goto A40
  else begin
    Dec(Value, 50); Result := Result + 'L';
  end;
  A10:
    while Value >= 10 do begin
    Dec(Value, 10); Result := Result + 'X';
  end;
  A9:
    if Value < 9 then goto A5
  else begin
    Result := Result + 'IX';
  end;
  Exit;
  A4:
    if Value < 4 then goto A1
  else begin
    Result := Result + 'IV';
  end;
  Exit;
  A5:
    if Value < 5 then goto A4
  else begin
    Dec(Value, 5); Result := Result + 'V';
  end;
  goto A1;
  A1:
    while Value >= 1 do begin
    Dec(Value); Result := Result + 'I';
  end;
end;


function TAzuliaStrings.GetDirFromStr(DirectoryString: string; IndexFromRight: integer): string;
var inp, temp1, temp2: string;
  Posi: integer;
begin
  inp := DirectoryString;
  if inp[Length(inp)] = '\' then inp[Length(inp)] := ' ';
  while Pos('\', inp) > 0 do
  begin
    posi := Pos('\', inp);
    inp[Pos('\', inp)] := ' ';
  end;
  Result := Copy(DirectoryString, Posi, Length(DirectoryString) - Posi + 1);
end;

function TAzuliaStrings.RemoveChars(InputString: string; CharToRemove: Char): string;
var
  a: Integer;
begin
  if InputString <> '' then
  begin
    for a := 0 to Length(InputString) do
    begin
      if InputString[a] = ' ' then Delete(InputString, a, 1);
    end;
  end;
  Result := InputString;
end;

function TAzuliaStrings.RemoveTrailingChars(StringToRemoveFrom: string; Trailer: char): string;
var a, eol: integer;
begin
  for a := Length(StringToRemoveFrom) downto 0 do
    if Length(StringToRemoveFrom) > 0 then
      if StringToRemoveFrom[a] <> Trailer then
      begin
        eol := a;
        Result := Copy(StringToRemoveFrom, 0, eol);
        Exit;
      end;
end;

function TAzuliaStrings.GetCount(Character: char; InputString: string): integer;
var it: integer;
begin
  result := 0;
  if length(InputString) > 0 then
    for it := 1 to length(InputString) do
      if InputString[it] = Character then inc(result);
end;


function TAzuliaStrings.GetStringFromGarbage(InputString: string; Index: integer): string;
var
  GarbagePos1, GarbagePos2: integer;
  Garbage: array[0..15] of char;
begin
  Garbage[0] := '=';
  Garbage[1] := '*';
  Garbage[2] := '$';
  Garbage[3] := 'Þ';
  Garbage[4] := '~';
  Garbage[5] := '£';
  Garbage[6] := '&';
  Garbage[7] := '^';
  Garbage[8] := '?';
  Garbage[9] := '¬';
  Garbage[10] := '@';
  Garbage[11] := 'ß';
  Garbage[12] := '±';
  Garbage[13] := 'ë';
  Garbage[14] := 'ñ';
  Garbage[15] := 'è';

  GarbagePos1 := Pos(Garbage[Index - 1], InputString) + 1;
  GarbagePos2 := Pos(Garbage[Index], InputString);

  Result := Copy(InputString, GarbagePos1, GarbagePos2 - GarbagePos1);
end;


function TAzuliaStrings.SplitupWithGarbage(InputString: string; CommonSplitter: char): string;
var
  a, c: integer;
  Garbage: array[0..15] of char;
begin
  Garbage[0] := '=';
  Garbage[1] := '*';
  Garbage[2] := '$';
  Garbage[3] := 'Þ';
  Garbage[4] := '~';
  Garbage[5] := '£';
  Garbage[6] := '&';
  Garbage[7] := '^';
  Garbage[8] := '?';
  Garbage[9] := '¬';
  Garbage[10] := '@';
  Garbage[11] := 'ß';
  Garbage[12] := '±';
  Garbage[13] := 'ë';
  Garbage[14] := 'ñ';
  Garbage[15] := 'è';

  c := 1;
  for a := 0 to Length(InputString) do
  begin
    if InputString[a] = CommonSplitter then
    begin
      InputString[a] := Garbage[c];
      Inc(c);
    end;
  end;
  Result := InputString + Garbage[c];
end;


{=================================================
                 Files
=================================================}

function TAzuliaFiles.GetKBFileSize(FileSize: integer): string;
begin
  result := '';
  if FileSize < 0 then exit;
  if FileSize < 1024 then
    result := inttostr(FileSize) + ' Bytes'
  else if FileSize < (1024 * 1024) then
    result := floattostrf(FileSize / 1024, ffgeneral, 3, 2) + ' KB'
  else if FileSize < (1024 * 1024 * 1024) then
    result := floattostrf(FileSize / (1024 * 1024), ffgeneral, 3, 2) + ' MiB'
  else
    result := floattostrf(FileSize / (1024 * 1024 * 1024), ffgeneral, 3, 2) + ' Gig'
end;

function TAzuliaFiles.LongToShortFilename(LongFilename: string): string;
var
  Long, Short: array[0..255] of Char;
begin
  StrPCopy(Long, LongFilename);
  GetShortPathName(Long, Short, 255);
  Result := string(Short);
end;

function TAzuliaFiles.ShortToLongFilename(LongFilename: string): string;
var
  Long, Short: array[0..255] of Char;
begin
  StrPCopy(Long, LongFilename);
  GetShortPathName(Long, Short, 255);
  Result := string(Short);
end;

function TAzuliaFiles.GetINIString(Section, Ident, DefaultString, Filename: string): string;
var INIFile: TINIFile;
begin
  INIFile := TINIFile.Create(Filename);
  Result := INIFile.ReadString(Section, Ident, DefaultString);
  INIFile.Free;
end;

{function TAzuliaFiles.WriteINIString(Section, Ident, DefaultString, Filename: string): string;
var INIFile: TINIFile;
begin
    INIFile := TINIFile.Create(Filename);
    Result := INIFile.WriteString(Section, Ident, DefaultString);
    INIFile.Free;
end; }

procedure TAzuliaFiles.SaveDataToFilename(Filename, Data: string);
var
  DataFile: TextFile;
begin
  AssignFile(DataFile, Filename);
  Rewrite(DataFile);
  Writeln(DataFile, Data);
  CloseFile(DataFile);
end;

procedure TAzuliaFiles.AppendDataToFilename(Filename, Data: string);
var
  DataFile: TextFile;
begin
  if FileExists(Filename) then
  begin
    AssignFile(DataFile, Filename);
    Append(DataFile);
    WriteLn(DataFile, Data);
    CloseFile(DataFile);
  end
  else
    SaveDataToFilename(Filename, data);
end;

function TAzuliaFiles.GetWindowsDir: string;
var
  WinDir: array[0..255] of Char;
begin
  GetWindowsDirectory(WinDir, 255);
  Result := string(WinDir);
end;

function TAzuliaFiles.GetTempDir: string;
var
  TempDir: array[0..255] of Char;
begin
  GetTempPath(255, TempDir);
  Result := string(TempDir);
end;



procedure TAzuliaFiles.SearchFileExt(const Dir, Ext: string; Files: TStrings);
var
  Found: TSearchRec;
  Sub: string;
  i: Integer;
  Dirs: TStrings; //Store sub-directories
  Finished: Integer; //Result of Finding
begin
  //	StopSearch := False;
  Dirs := TStringList.Create;
  Finished := FindFirst(Dir + '*.*', 63, Found);
  while (Finished = 0) do
  begin
    //Check if the name is valid.
    if (Found.Name[1] <> '.') then
    begin
      //Check if file is a directory
      if (Found.Attr and faDirectory = faDirectory) then
        Dirs.Add(Dir + Found.Name) //Add to the directories list.
      else
        if Pos(UpperCase(Ext), UpperCase(Found.Name)) > 0 then
          Files.Add(Dir + Found.Name);
    end;
    Finished := FindNext(Found);
  end;
  //end the search process.
  FindClose(Found);
  //Check if any sub-directories found
 //if not StopSearch then
  for i := 0 to Dirs.Count - 1 do
    //If sub-dirs then search agian ~>~>~> on and on, until it is done.
    SearchFileExt(Dirs[i], Ext, Files);

  //Clear the memories.
  Dirs.Free;
end;


procedure TAzuliaFiles.FindRecursive(const path: string; const mask: string;
  LogFunction: TLogFunct; Re_curse: Boolean);
var
  fullpath: string;

  function Recurse(var path: string; const mask: string; Re_curse: Boolean): Boolean;
  var
    SRec: TSearchRec;
    retval: Integer;
    oldlen: Integer;
  begin
    //Recurse := FALSE;
    Recurse := Re_Curse;
    oldlen := Length(path);
    retval := FindFirst(path + mask, faAnyFile, SRec);
    while retval = 0 do
    begin
      if (SRec.Attr and (faDirectory or faVolumeID)) = 0 then
        if not LogFunction(path, SRec) then
        begin
          Result := False;
          Break;
        end;
      retval := FindNext(SRec);
    end;
    FindClose(SRec);
    if not Result then Exit;
    retval := FindFirst(path + '*.*', faDirectory, SRec);
    while retval = 0 do
    begin
      if (SRec.Attr and faDirectory) <> 0 then
        if (SRec.Name <> '.') and (SRec.Name <> '..') then
        begin
          path := path + SRec.Name + '\';
          if not Recurse(path, mask, Re_curse) then
          begin
            Result := False;
            Break;
          end;
          Delete(path, oldlen + 1, 255);
        end;
      retval := FindNext(SRec);
    end;
    FindClose(SRec);
  end;
begin
  if path = '' then
    GetDir(0, fullpath)
  else
    fullpath := path;
  if fullpath[Length(fullpath)] <> '\' then
    fullpath := fullpath + '\';
  if mask = '' then
    Recurse(fullpath, '*.*', Re_curse)
  else
    Recurse(fullpath, mask, Re_curse);
end;

function TAzuliaFiles.HasAttr(const FileName: string; Attr: Word): Boolean;
begin
  Result := (FileGetAttr(FileName) and Attr) = Attr;
end;

procedure TAzuliaFiles.CopyFile(const FileName, DestName: string);
var
  CopyBuffer: Pointer;
  BytesCopied: Longint;
  Source, Dest: Integer;
  Destination: TFileName;
const
  ChunkSize: Longint = 8192;
begin
  Destination := ExpandFileName(DestName);


  if HasAttr(Destination, faDirectory) then
    Destination := Destination + '\' + ExtractFileName(FileName);


  GetMem(CopyBuffer, ChunkSize);
  try
    Source := FileOpen(FileName, fmShareDenyWrite);
    if Source < 0 then raise EFOpenError.CreateFmt(SFOpenError, [FileName]);
    try
      Dest := FileCreate(Destination);
      if Dest < 0 then raise EFCreateError.CreateFmt('SFCreateError', [Destination]);
      try
        repeat
          BytesCopied := FileRead(Source, CopyBuffer^, ChunkSize);
          if BytesCopied > 0 then
            FileWrite(Dest, CopyBuffer^, BytesCopied);
        until BytesCopied < ChunkSize;
      finally
        FileClose(Dest);
      end;
    finally
      FileClose(Source);
    end;
  finally
    FreeMem(CopyBuffer, ChunkSize);
  end;
end;

procedure TAzuliaFiles.MoveFile(const FileName, DestName: string);
var
  Destination: string;
begin
  Destination := ExpandFileName(DestName);
  if not RenameFile(FileName, Destination) then
  begin
    if HasAttr(FileName, faReadOnly) then
      raise EFCantMove.Create(Format(SFCantMove, [FileName]));
    CopyFile(FileName, Destination);
  end;
end;

function TAzuliaFiles.GetFileSize(const FileName: string): LongInt;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else Result := -1;
end;

function TAzuliaFiles.ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..255] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil, StrPCopy(zFileName, FileName), StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
end;

{=================================================
                DO I EXIST?
=================================================}

function DoIExist(WndTitle: string): Boolean;
var
  hSem: THandle;
  hWndMe: HWnd;
  semNm,
    wTtl: array[0..256] of Char;
begin
  Result := False;
  StrPCopy(semNm, 'SemaphoreName');
  StrPCopy(wTtl, WndTitle);
  hSem := CreateSemaphore(nil, 0, 1, semNm);
  if ((hSem <> 0) and (GetLastError() = ERROR_ALREADY_EXISTS)) then
  begin
    CloseHandle(hSem);
    hWndMe := FindWindow(nil, wTtl);
    SetWindowText(hWndMe, 'zzzzzzz');
    hWndMe := FindWindow(nil, wTtl);
    if (hWndMe <> 0) then
    begin
      if IsIconic(hWndMe) then
        ShowWindow(hWndMe, SW_SHOWNORMAL)
      else
        SetForegroundWindow(hWndMe);
    end;
    Result := True;
  end;
end;


{=================================================
                Azulia DISK
=================================================}

function TAzuliaDisk.GetDiskLabel(Drive: char): string;
begin
  ExamineDrive(Drive);
  Result := FDiskLabel;
end;

function TAzuliaDisk.GetDiskSerial(Drive: char): string;
begin
  ExamineDrive(Drive);
  Result := FDiskSerial;
end;

function TAzuliaDisk.GetDiskFileSystem(Drive: char): string;
begin
  ExamineDrive(Drive);
  Result := FFileSystem;
end;

function TAzuliaDisk.GetDiskType(Drive: char): integer;
begin
  ExamineDrive(Drive);
  Result := FDriveType;
end;

function TAzuliaDisk.GetDiskFlags(Drive: char): integer;
begin
  ExamineDrive(Drive);
  Result := FDriveFlags;
end;

procedure TAzuliaDisk.ChangeDiskLabel(Drive: char; NewLabel: string);
begin
  if FDiskLabel <> NewLabel then
    SetVolumeLabel(PChar(Drive + ':\'), PChar(NewLabel));
end;

procedure TAzuliaDisk.ExamineDrive(Drive: char);
var
  Serial: DWord;
  DirLen: DWord;
  SystemFlags: DWord;
  FileSys: array[0..12] of Char;
  DLabel: array[0..12] of Char;
begin
  GetVolumeInformation(PChar(Drive + ':\'), @DLabel, 12, @Serial, DirLen, SystemFlags, @FileSys, 12);
  FDiskLabel := DLabel;
  FDiskSerial := IntToHex(Serial, 8);
  FFileSystem := FileSys;
  FDriveType := GetDriveType(PChar(Drive + ':\'));
  FDriveFlags := SystemFlags;
end;







function TAzuliaHTML.HeadTop(Title: string): string;
begin
  Result := '<HEAD><TITLE>' + Title + '</TITLE>';
end;

function TAzuliaHTML.HeadClose: string;
begin
  Result := '</HEAD>';
end;

function TAzuliaHTML.BodyTop(LeftMargin, RightMargin: Integer; TextColor, LinkColor, VisitedLinkColor, ActiveLinkColor, BackgroundColor, BackgroundImage: string; FixedBackground: bool; Extra: string): string;
var BGPROP: string;
begin
  if FixedBackground then BGPROP := 'FIXED' else BGPROP := '';
  Result := '<BODY LEFTMARGIN="' + IntToStr(LeftMargin) + '" RIGHTMARGIN="' + IntToStr(RightMargin) + '" TEXT=' + TextColor + ' LINK=' + LinkColor + ' VLINK=' + VisitedLinkColor + ' ALINK=' + ActiveLinkColor + ' BGCOLOR=' + BackgroundColor + ' BACKGROUND="' + BackgroundImage + '" BGPROPERTIES="' + BGPROP + '" ' + Extra + '>';
end;

function TAzuliaHTML.BodyClose: string;
begin
  Result := '</BODY>';
end;

function TAzuliaHTML.ConvertDOSPathToHTML(WindowsPath: string): string;
var a: integer;
begin
  while pos('\', WindowsPath) > 0 do WindowsPath[pos('\', WindowsPath)] := '/';
  while pos(' ', WindowsPath) > 0 do
  begin
    a := pos(' ', WindowsPath);
    Delete(WindowsPath, a, 1);
    Insert('%20', WindowsPath, a);
  end;
  Result := WindowsPath;
end;

function TAzuliaHTML.ConvertHTMLPathToDOS(WindowsPath: string): string;
begin
  while pos('/', WindowsPath) > 0 do WindowsPath[pos('/', WindowsPath)] := '/';
  Result := WindowsPath;
end;

//
//
//
//

procedure TAzuliaSpeaker.NoSound;
var
  wValue: Word;
begin
  wValue := GetPort($61);
  wValue := wValue and $FC;
  SetPort($61, wValue);
end;

procedure TAzuliaSpeaker.Sound(Freq: Word);
var
  B: Word;
begin
  if Freq > 18 then begin
    Freq := Word(1193181 div LongInt(Freq));

    B := GetPort($61);

    if (B and 3) = 0 then begin
      SetPort($61, B or 3);
      SetPort($43, $B6);
    end;

    SetPort($42, Freq);
    SetPort($42, (Freq shr 8));
  end;
end;

procedure TAzuliaSpeaker.Delay(MSecs: Integer);
var
  FirstTickCount: LongInt;
begin
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages; {allowing access to other controls, etc.}
  until ((GetTickCount - FirstTickCount) >= LongInt(MSecs));
end;

procedure TAzuliaSpeaker.Play(Freq: Word; MSecs: Integer);
begin
  Sound(Freq);
  Delay(MSecs);
  NoSound;
end;

procedure TAzuliaSpeaker.Stop;
begin
  NoSound;
end;

procedure TAzuliaSpeaker.SetPort(address, value: Word);
var
  bValue: Byte;
begin
  bValue := trunc(value and 255);
  asm
      mov DX, address
      mov AL, bValue
      out DX, AL
  end;
end;

function TAzuliaSpeaker.GetPort(address: Word): Word;
var
  bValue: Byte;
begin
  asm
      mov DX, address
      in  AL, DX
      mov bValue, AL
  end;
  result := bValue;
end;


function ToggleBool(totoggle: bool): bool;
begin
  if totoggle = true then result := false;
  if totoggle = false then result := true;
end;



procedure SaveListViewToFile(AListView: TListView; sFileName: string);
var 
  idxItem, idxSub, IdxImage: Integer; 
  F: TFileStream; 
  pText: PChar; 
  sText: string; 
  W, ItemCount, SubCount: Word; 
  MySignature: array [0..2] of Char; 
begin 
  //Initialization 
  with AListView do 
  begin 
    ItemCount := 0; 
    SubCount  := 0; 
    //**** 
    MySignature := 'LVF'; 
    //  ListViewFile 
    F := TFileStream.Create(sFileName, fmCreate or fmOpenWrite); 
    F.Write(MySignature, SizeOf(MySignature)); 

    if Items.Count = 0 then 
      // List is empty 
      ItemCount := 0 
    else 
      ItemCount := Items.Count; 
    F.Write(ItemCount, SizeOf(ItemCount)); 

    if Items.Count > 0 then 
    begin 
      for idxItem := 1 to ItemCount do 
      begin 
        with Items[idxItem - 1] do 
        begin 
          //Save subitems count 
          if SubItems.Count = 0 then 
            SubCount := 0 
          else 
            SubCount := Subitems.Count; 
          F.Write(SubCount, SizeOf(SubCount)); 
          //Save ImageIndex 
          IdxImage := ImageIndex; 
          F.Write(IdxImage, SizeOf(IdxImage)); 
          //Save Caption 
          sText := Caption; 
          w     := Length(sText); 
          pText := StrAlloc(Length(sText) + 1); 
          StrPLCopy(pText, sText, Length(sText)); 
          F.Write(w, SizeOf(w)); 
          F.Write(pText^, w); 
          StrDispose(pText); 
          if SubCount > 0 then 
          begin 
            for idxSub := 0 to SubItems.Count - 1 do 
            begin 
              //Save Item's subitems 
              sText := SubItems[idxSub]; 
              w     := Length(sText); 
              pText := StrAlloc(Length(sText) + 1); 
              StrPLCopy(pText, sText, Length(sText)); 
              F.Write(w, SizeOf(w)); 
              F.Write(pText^, w); 
              StrDispose(pText); 
            end; 
          end; 
        end; 
      end; 
    end; 
    F.Free; 
  end; 
end; 



procedure LoadListViewToFile(AListView: TListView; sFileName: string);
var 
  F: TFileStream; 
  IdxItem, IdxSubItem, IdxImage: Integer; 
  W, ItemCount, SubCount: Word; 
  pText: PChar; 
  PTemp: PChar; 
  MySignature: array [0..2] of Char; 
  sExeName: string; 
begin 
  with AListView do 
  begin 
    ItemCount := 0; 
    SubCount  := 0; 

    sExeName := ExtractFileName(sFileName); 

    if not FileExists(sFileName) then 
    begin 
      MessageBox(Handle, PChar(Format(SFOpenError, [sExeName])), 'I/O Error', MB_ICONERROR);
      Exit; 
    end; 

    F := TFileStream.Create(sFileName, fmOpenRead); 
    F.Read(MySignature, SizeOf(MySignature)); 

    if MySignature <> 'LVF' then 
    begin 
      MessageBox(Handle, PChar(Format(Msg2, [sExeName])), 'I/O Error', MB_ICONERROR); 
      Exit; 
    end; 

    F.Read(ItemCount, SizeOf(ItemCount)); 
    Items.Clear; 

    for idxItem := 1 to ItemCount do 
    begin 
      with Items.Add do 
      begin 
        //Read imageindex 
        F.Read(SubCount, SizeOf(SubCount)); 
        //Read imageindex 
        F.Read(IdxImage, SizeOf(IdxImage)); 
        ImageIndex := IdxImage; 
        //Read the Caption 
        F.Read(w, SizeOf(w)); 
        pText := StrAlloc(w + 1); 
        pTemp := StrAlloc(w + 1); 
        F.Read(pTemp^, W); 
        StrLCopy(pText, pTemp, W); 
        Caption := StrPas(pText); 
        StrDispose(pTemp); 
        StrDispose(pText); 
        if SubCount > 0 then 
        begin 
          for idxSubItem := 1 to SubCount do 
          begin 
            F.Read(w, SizeOf(w)); 
            pText := StrAlloc(w + 1); 
            pTemp := StrAlloc(w + 1); 
            F.Read(pTemp^, W); 
            StrLCopy(pText, pTemp, W); 
            Items[idxItem - 1].SubItems.Add(StrPas(pText)); 
            StrDispose(pTemp); 
            StrDispose(pText); 
          end; 
        end; 
      end; 
    end; 

    F.Free; 
  end; 
end; 


{

  Before importing an image (jpg) into a database,
  I would like to resize it (reduce its size) and
  generate the corresponding smaller file. How can I do this?


  Load the JPEG into a bitmap, create a new bitmap
  of the size that you want and pass them both into
  SmoothResize then save it again ...
  there's a neat routine JPEGDimensions that
  gets the JPEG dimensions without actually loading the JPEG into a bitmap,
  saves loads of time if you only need to test its size before resizing.
}



type
  TRGBArray = array[Word] of TRGBTriple;
  pRGBArray = ^TRGBArray;

{---------------------------------------------------------------------------
-----------------------}

procedure SmoothResize(Src, Dst: TBitmap);
var
  x, y: Integer;
  xP, yP: Integer;
  xP2, yP2: Integer;
  SrcLine1, SrcLine2: pRGBArray;
  t3: Integer;
  z, z2, iz2: Integer;
  DstLine: pRGBArray;
  DstGap: Integer;
  w1, w2, w3, w4: Integer;
begin
  Src.PixelFormat := pf24Bit;
  Dst.PixelFormat := pf24Bit;

  if (Src.Width = Dst.Width) and (Src.Height = Dst.Height) then
    Dst.Assign(Src)
  else
  begin
    DstLine := Dst.ScanLine[0];
    DstGap  := Integer(Dst.ScanLine[1]) - Integer(DstLine);

    xP2 := MulDiv(pred(Src.Width), $10000, Dst.Width);
    yP2 := MulDiv(pred(Src.Height), $10000, Dst.Height);
    yP  := 0;

    for y := 0 to pred(Dst.Height) do
    begin
      xP := 0;

      SrcLine1 := Src.ScanLine[yP shr 16];

      if (yP shr 16 < pred(Src.Height)) then
        SrcLine2 := Src.ScanLine[succ(yP shr 16)]
      else
        SrcLine2 := Src.ScanLine[yP shr 16];

      z2  := succ(yP and $FFFF);
      iz2 := succ((not yp) and $FFFF);
      for x := 0 to pred(Dst.Width) do
      begin
        t3 := xP shr 16;
        z  := xP and $FFFF;
        w2 := MulDiv(z, iz2, $10000);
        w1 := iz2 - w2;
        w4 := MulDiv(z, z2, $10000);
        w3 := z2 - w4;
        DstLine[x].rgbtRed := (SrcLine1[t3].rgbtRed * w1 +
          SrcLine1[t3 + 1].rgbtRed * w2 +
          SrcLine2[t3].rgbtRed * w3 + SrcLine2[t3 + 1].rgbtRed * w4) shr 16;
        DstLine[x].rgbtGreen :=
          (SrcLine1[t3].rgbtGreen * w1 + SrcLine1[t3 + 1].rgbtGreen * w2 +

          SrcLine2[t3].rgbtGreen * w3 + SrcLine2[t3 + 1].rgbtGreen * w4) shr 16;
        DstLine[x].rgbtBlue := (SrcLine1[t3].rgbtBlue * w1 +
          SrcLine1[t3 + 1].rgbtBlue * w2 +
          SrcLine2[t3].rgbtBlue * w3 +
          SrcLine2[t3 + 1].rgbtBlue * w4) shr 16;
        Inc(xP, xP2);
      end; {for}
      Inc(yP, yP2);
      DstLine := pRGBArray(Integer(DstLine) + DstGap);
    end; {for}
  end; {if}
end; {SmoothResize}

{---------------------------------------------------------------------------
-----------------------}

function LoadJPEGPictureFile(Bitmap: TBitmap; FilePath, FileName: string): Boolean;
var
  JPEGImage: TJPEGImage;
begin
  if (FileName = '') then    // No FileName so nothing
    Result := False  //to load - return False...
  else
  begin
    try  // Start of try except
      JPEGImage := TJPEGImage.Create;  // Create the JPEG image... try  // now
      try  // to load the file but
        JPEGImage.LoadFromFile(FilePath + FileName);
        // might fail...with an Exception.
        Bitmap.Assign(JPEGImage);
        // Assign the image to our bitmap.Result := True;
        // Got it so return True.
      finally
        JPEGImage.Free;  // ...must get rid of the JPEG image. finally
      end; {try}
    except
      Result := False; // Oops...never Loaded, so return False.
    end; {try}
  end; {if}
end; {LoadJPEGPictureFile}


{---------------------------------------------------------------------------
-----------------------}


function SaveJPEGPictureFile(Bitmap: TBitmap; FilePath, FileName: string; Quality: Integer): Boolean;
begin
  Result := True;
  try
    if ForceDirectories(FilePath) then
    begin
      with TJPegImage.Create do
      begin
        try
          Assign(Bitmap);
          CompressionQuality := Quality;
          SaveToFile(FilePath + FileName);
        finally
          Free;
        end; {try}
      end; {with}
    end; {if}
  except
    raise;
    Result := False;
  end; {try}
end; {SaveJPEGPictureFile}


{---------------------------------------------------------------------------
-----------------------}


procedure ResizeImage(FileName: string; MaxWidth: Integer);
var
  OldBitmap: TBitmap;
  NewBitmap: TBitmap;
  aWidth: Integer;
begin
  OldBitmap := TBitmap.Create;
  try
    if LoadJPEGPictureFile(OldBitmap, ExtractFilePath(FileName),
      ExtractFileName(FileName)) then
    begin
      aWidth := OldBitmap.Width;
      if (OldBitmap.Width > MaxWidth) then
      begin
        aWidth    := MaxWidth;
        NewBitmap := TBitmap.Create;
        try
          NewBitmap.Width  := MaxWidth;
          NewBitmap.Height := MulDiv(MaxWidth, OldBitmap.Height, OldBitmap.Width);
          SmoothResize(OldBitmap, NewBitmap);
          RenameFile(FileName, ChangeFileExt(FileName, '.$$$'));
          if SaveJPEGPictureFile(NewBitmap, ExtractFilePath(FileName),
            ExtractFileName(FileName), 75) then
            DeleteFile(ChangeFileExt(FileName, '.$$$'))
          else
            RenameFile(ChangeFileExt(FileName, '.$$$'), FileName);
        finally
          NewBitmap.Free;
        end; {try}
      end; {if}
    end; {if}
  finally
    OldBitmap.Free;
  end; {try}
end;


{---------------------------------------------------------------------------
-----------------------}

function JPEGDimensions(Filename : string; var X, Y : Word) : boolean;
var
  SegmentPos : Integer;
  SOIcount : Integer;
  b : byte;
begin
  Result  := False;
  with TFileStream.Create(Filename, fmOpenRead or fmShareDenyNone) do
  begin
    try
      Position := 0;
      Read(X, 2);
      if (X <> $D8FF) then
        exit;
      SOIcount  := 0;
      Position  := 0;
      while (Position + 7 < Size) do
      begin
        Read(b, 1);
        if (b = $FF) then begin
          Read(b, 1);
          if (b = $D8) then
            inc(SOIcount);
          if (b = $DA) then
            break;
        end; {if}
      end; {while}
      if (b <> $DA) then
        exit;
      SegmentPos  := -1;
      Position    := 0;
      while (Position + 7 < Size) do
      begin
        Read(b, 1);
        if (b = $FF) then
        begin
          Read(b, 1);
          if (b in [$C0, $C1, $C2]) then
          begin
            SegmentPos  := Position;
            dec(SOIcount);
            if (SOIcount = 0) then
              break;
          end; {if}
        end; {if}
      end; {while}
      if (SegmentPos = -1) then
        exit;
      if (Position + 7 > Size) then
        exit;
      Position := SegmentPos + 3;
      Read(Y, 2);
      Read(X, 2);
      X := Swap(X);
      Y := Swap(Y);
      Result  := true;
    finally
      Free;
    end; {try}
  end; {with}
end; {JPEGDimensions}



begin
  DriveType[0] := 'Unknown';
  DriveType[1] := 'Unknown';
  DriveType[2] := 'Removable';
  DriveType[3] := 'Fixed';
  DriveType[4] := 'Network';
  DriveType[5] := 'CD-ROM';
  DriveType[6] := 'RAM';

  Alphabet[01] := 'a';
  Alphabet[02] := 'b';
  Alphabet[03] := 'c';
  Alphabet[04] := 'd';
  Alphabet[05] := 'e';
  Alphabet[06] := 'f';
  Alphabet[07] := 'g';
  Alphabet[08] := 'h';
  Alphabet[09] := 'i';
  Alphabet[10] := 'j';
  Alphabet[11] := 'k';
  Alphabet[12] := 'l';
  Alphabet[13] := 'm';
  Alphabet[14] := 'n';
  Alphabet[15] := 'o';
  Alphabet[16] := 'p';
  Alphabet[17] := 'q';
  Alphabet[18] := 'r';
  Alphabet[19] := 's';
  Alphabet[20] := 't';
  Alphabet[21] := 'u';
  Alphabet[22] := 'v';
  Alphabet[23] := 'w';
  Alphabet[24] := 'x';
  Alphabet[25] := 'y';
  Alphabet[26] := 'z';
end.

