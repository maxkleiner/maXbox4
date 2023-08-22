//------------------------------------------------------------------------------
//  Diverse Konstanten, Funktionen etc.
//  DelphiMmc20 framework
//  Copyright (c) 2008 Jens Geyer und Toolbox-Verlag.
//------------------------------------------------------------------------------
unit CommonTools;

interface

uses Classes, Windows, SysUtils, ComServ, ShellApi;

const
  BYTES  = 1;
  KBYTES = 1024;
  MBYTES = KBYTES * KBYTES;
  GBYTES = MBYTES * KBYTES;

  {$IFDEF Debug}
  DBG_ALIVE      = Integer($11BABE11);
  DBG_DESTROYING = Integer($44FADE44);
  DBG_GONE       = Integer($99AC1D99);
  {$ENDIF}

  // namespace GUIDs
  SHELL_NS_MYCOMPUTER = '::{20D04FE0-3AEA-1069-A2D8-08002B30309D}';


type
  // macht bestimmte protected-Methoden public, als Cast einsetzen
  MakeComServerMethodsPublic = class( TComServer)
  public
    function CountObject(Created: Boolean): Integer; override;
  end;

  // ein paar Datei-Infos abrufen
  TSomeFileInfo = ( fi_DisplayType,  // Dateityp wie im Windows Exploder
                    fi_Application   // assoziierte Anwendung (if any)
                  );


// Flags und Bits
function  IsFlagSet( dwTestForFlag, dwFlagSet : DWORD) : Boolean;
procedure SetFlag( const dwThisFlag : DWORD; var dwFlagSet : DWORD; aSet : Boolean);

// Tempfiles
function  GetTempFolder : string;
function  GetTempFile : string;

// Versionsinfo
function  GetModuleFilename : string;
function  FormatModuleVersionInfo( const aFilename : string) : string;
function  GetVersionInfoString( const aFile, aEntry : string; aLang : WORD) : string;

// Dateiinformationen
function  GetFileSize( aFile : string; aMultipleOf : Integer = KBYTES) : Integer;
function  FormatAttribString( aAttr : Integer) : string;
function  GetSomeFileInfo( aFile : string; aWhatInfo : TSomeFileInfo) : string;

// ShellApi
function  ShellRecycle( aWnd : HWND; aFileOrFolder : string) : Boolean;

// Debugging
function  IsDebuggerPresent : BOOL;  stdcall;
function  NotImplemented : HRESULT;


implementation


//--- MakeComServerMethodsPublic -----------------------------------------------


function MakeComServerMethodsPublic.CountObject(Created: Boolean): Integer;
begin
  result := inherited CountObject(Created);
end;


//--- Tools --------------------------------------------------------------------

// imports
type
  ASSOCF   = type DWORD;
  ASSOCSTR = type DWORD;

const
  VERSION_DLL = 'version.dll';
  SHLWAPI_DLL = 'shlwapi.dll';

  ASSOCF_INIT_NOREMAPCLSID          = ASSOCF($00000001);
  ASSOCF_INIT_BYEXENAME             = ASSOCF($00000002);
  ASSOCF_OPEN_BYEXENAME             = ASSOCF($00000002);
  ASSOCF_INIT_DEFAULTTOSTAR         = ASSOCF($00000004);
  ASSOCF_INIT_DEFAULTTOFOLDER       = ASSOCF($00000008);
  ASSOCF_NOUSERSETTINGS             = ASSOCF($00000010);
  ASSOCF_NOTRUNCATE                 = ASSOCF($00000020);
  ASSOCF_VERIFY                     = ASSOCF($00000040);
  ASSOCF_REMAPRUNDLL                = ASSOCF($00000080);
  ASSOCF_NOFIXUPS                   = ASSOCF($00000100);
  ASSOCF_IGNOREBASECLASS            = ASSOCF($00000200);
  ASSOCF_INIT_IGNOREUNKNOWN         = ASSOCF($00000400);

  ASSOCSTR_COMMAND                  = ASSOCSTR(1);
  ASSOCSTR_EXECUTABLE               = ASSOCSTR(2);
  ASSOCSTR_FRIENDLYDOCNAME          = ASSOCSTR(3);
  ASSOCSTR_FRIENDLYAPPNAME          = ASSOCSTR(4);
  ASSOCSTR_NOOPEN                   = ASSOCSTR(5);
  ASSOCSTR_SHELLNEWVALUE            = ASSOCSTR(6);
  ASSOCSTR_DDECOMMAND               = ASSOCSTR(7);
  ASSOCSTR_DDEIFEXEC                = ASSOCSTR(8);
  ASSOCSTR_DDEAPPLICATION           = ASSOCSTR(9);
  ASSOCSTR_DDETOPIC                 = ASSOCSTR(10);
  ASSOCSTR_INFOTIP                  = ASSOCSTR(11);
  ASSOCSTR_QUICKTIP                 = ASSOCSTR(12);
  ASSOCSTR_TILEINFO                 = ASSOCSTR(13);
  ASSOCSTR_CONTENTTYPE              = ASSOCSTR(14);
  ASSOCSTR_DEFAULTICON              = ASSOCSTR(15);
  ASSOCSTR_SHELLEXTENSION           = ASSOCSTR(16);

function GetFileVersionInfoSize( pcFilename: PChar; var dwHandle: DWORD): DWORD;
stdcall; external VERSION_DLL name 'GetFileVersionInfoSizeA';

function GetFileVersionInfo( pcFilename: PChar; dwHandle, dwLen: DWORD; pDataBuf: Pointer): BOOL;
stdcall; external VERSION_DLL name 'GetFileVersionInfoA';

function VerQueryValue( pBlock: Pointer; pcSubBlock: PChar; var lpBuffer: Pointer; var uLen: UINT): BOOL;
stdcall; external VERSION_DLL name 'VerQueryValueA';

// BUG: die ANSI-Version returniert die benötigte Buffersize nicht -> UNICODE verwenden
function AssocQueryStringW( flags : ASSOCF; str : ASSOCSTR; pszAssoc, pszExtra, pszOut : PWideChar; var cchOut : DWORD) : HRESULT;
stdcall; external SHLWAPI_DLL name 'AssocQueryStringW';

type
  VS_FIXEDFILEINFO = record  // vsffi
    dwSignature : DWORD;
    dwStrucVersion : DWORD;
    dwFileVersionMS : DWORD;
    dwFileVersionLS : DWORD;
    dwProductVersionMS : DWORD;
    dwProductVersionLS : DWORD;
    dwFileFlagsMask : DWORD;
    dwFileFlags : DWORD;
    dwFileOS : DWORD;
    dwFileType : DWORD;
    dwFileSubtype : DWORD;
    dwFileDateMS : DWORD;
    dwFileDateLS : DWORD;
  end;


//--- Implementierung ----------------------------------------------------------


function GetVersionInfoString( const aFile, aEntry : string; aLang : WORD) : string;
// Liefert einen der folgenden vordefinierten Werte: Comments, InternalName,
// ProductName, CompanyName, LegalCopyright, ProductVersion, FileDescription,
// LegalTrademarks, PrivateBuild, FileVersion, OriginalFilename,SpecialBuild
type TTranslation = record wLang : WORD; wCP : WORD; end;
     PTranslation = ^TTranslation;
const
  TMPL_KEY  = '\StringFileInfo\%.04X%.04X\%s';
  MASK_LANG = $03FF;
  MASK_SUBL = $FC00;
var dwHandle, dwSize : DWORD;
    pBuf : Pointer;
    pTrans, pBest : PTranslation;
    i, nTrans : Integer;
    sKey   : string;
    match, newmatch : ( NO_MATCH, ACCEPTABLE, GOOD, BETTER, PERFECT);
    pcData : PChar;
begin
  result := '';

  dwSize := GetFileVersionInfoSize( PChar(aFile), dwHandle);
  if dwSize = 0 then Exit;

  GetMem( pBuf, dwSize);
  try
    if not GetFileVersionInfo( PChar(aFile), dwHandle, dwSize, pBuf)
    then Exit;

    // Translations lesen, mehrere möglich
    if not VerQueryValue( pBuf, 'VarFileInfo\Translation', Pointer(pTrans), dwSize)
    then Exit;

    // Translations durchgehen, besten Wert suchen
    pBest  := pTrans;
    match  := NO_MATCH;
    nTrans := dwSize div SizeOf(TTranslation);
    for i := 0 to nTrans-1 do begin
      if pTrans^.wLang = 0  // neutral
      then newmatch := ACCEPTABLE
      else newmatch := NO_MATCH;

      if (pTrans^.wLang and MASK_LANG) = (aLang and MASK_LANG) then begin
        if       pTrans^.wLang = aLang            then newmatch := PERFECT
        else if (pTrans^.wLang and MASK_SUBL) = 0 then newmatch := BETTER
        else                                           newmatch := GOOD;
      end;

      if newmatch > match then begin
        pBest := pTrans;
        match := newmatch;
      end;  
    end;

    // den Wert auslesen
    sKey   := Format( TMPL_KEY, [pBest^.wLang, pBest^.wCP, aEntry]);
    if VerQueryValue( pBuf, PChar(sKey), Pointer(pcData), dwSize)
    then result := pcData;

  finally
    FreeMem(pBuf);
  end;
end;


function FormatModuleVersionInfo( const aFilename : string) : string;
var dwHandle, dwSize : DWORD;
    pBuf : Pointer;
    pffi : ^VS_FIXEDFILEINFO;
    uLen : UINT;
const TMPL_VERSIONSTRING = '%d.%d.%d.%d';
begin
  result := Format( TMPL_VERSIONSTRING, [0,0,0,0]);

  dwSize := GetFileVersionInfoSize( PChar(aFilename), dwHandle);
  if dwSize = 0 then Exit;

  GetMem( pBuf, dwSize);
  try
    if not GetFileVersionInfo( PChar(aFilename), dwHandle, dwSize, pBuf)
    then Exit;

    pffi := nil;
    if not VerQueryValue( pBuf, '\', Pointer(pffi), uLen) then Exit;
    ASSERT( pffi <> nil);

    result := Format( TMPL_VERSIONSTRING,
                      [HiWord(pffi^.dwFileVersionMS),
                       LoWord(pffi^.dwFileVersionMS),
                       HiWord(pffi^.dwFileVersionLS),
                       LoWord(pffi^.dwFileVersionLS)
                      ]);

  finally
    FreeMem(pBuf);
  end;
end;


function GetTempFolder : string;
var acBuf : array[0..MAX_PATH] of char;
    ilen  : Integer;
begin
  iLen := GetTempPath(MAX_PATH,acBuf);
  if iLen <= MAX_PATH then begin
    SetString( result, acBuf, iLen);
    Exit;
  end;

  SetString( result, nil, iLen+1);
  GetTempPath( iLen, @result[1])
end;


function GetTempFile : string;
var acBuf : array[0..MAX_PATH] of char;
    ilen  : Integer;
begin
  result := '';
  iLen := GetTempFileName( PChar( GetTempFolder), '~tb', 0, acBuf);
  if iLen <= MAX_PATH then begin
    SetString( result, acBuf, iLen);
    ASSERT( iLen > 0);  // 0 = Fehler -> GetLastError() befragen
  end;
end;


function GetModuleFilename : string;
const BUFSIZE = 4096;
var buf : array[0..BUFSIZE] of Char;
begin
  if Windows.GetModuleFileName( HInstance, buf, BUFSIZE) <> 0
  then result := buf
  else result := 'GetModuleFileName() failed, '+SysErrorMessage(GetLastError);
end;


function GetFileSize( aFile : string; aMultipleOf : Integer = KBYTES) : Integer;
// Liefert die Größe einer einzelnen Datei
var srec : TSearchRec;
    iRes : Integer;
const ATTRIBS = faAnyFile and not (faDirectory or faVolumeID);
begin
  iRes := FindFirst( aFile, ATTRIBS, srec);
  try
    if (iRes = ERROR_SUCCESS) and ((srec.Attr and faDirectory) = 0)
    then result := srec.Size
    else result := 0;

    if (result > 0) and (aMultipleOf > 1) then begin
      iRes   := result mod aMultipleOf;
      result := result div aMultipleOf;
      if iRes > 0 then Inc(result);   // angefangene KB, wie Explorer
    end;

  finally
    FindClose( srec);
  end;
end;


function FormatAttribString( aAttr : Integer) : string;
// formatiert einen String für Datei/Verzeichnisattribute
var i : Integer;
const ATTRSTR : array[0..6] of Char = 'RHSLVAY';
begin
  result := '';
  for i := Low(ATTRSTR) to High(ATTRSTR) do begin
    if ((1 shl i) and aAttr) <> 0
    then result := result + ATTRSTR[i];
  end;
end;


function GetSomeFileInfo( aFile : string; aWhatInfo : TSomeFileInfo) : string;
// liefert einige Datei-Infos
var i      : Integer;
    dwSize : DWORD;
    pcOut  : PWideChar;
    sExt   : WideString;
    sOut   : WideString;
const FLAGS = ASSOCF_NOTRUNCATE or ASSOCF_REMAPRUNDLL or ASSOCF_INIT_DEFAULTTOSTAR;
begin
  result := '';
  sExt   := ExtractFileExt(aFile);

  for i := 0 to 1 do begin

    // 0 = Größe bestimmen, 1 = Buffer allozieren
    if i = 0 then begin
      dwSize := 0;
      pcOut  := nil;
    end else begin
      SetLength( sOut, dwSize);
      pcOut  := PWideChar( sOut);
    end;

    // was war es noch gleich?
    case aWhatInfo of
      fi_DisplayType :
        AssocQueryStringW( FLAGS, ASSOCSTR_FRIENDLYDOCNAME,
                           PWideChar(sExt), nil, pcOut, dwSize);

      fi_Application :
        AssocQueryStringW( FLAGS, ASSOCSTR_FRIENDLYAPPNAME,
                           PWideChar(sExt), nil, pcOut, dwSize);
    end;
  end;

  // Nullterminator absägen
  if dwSize > 0
  then result := Copy(sOut,1,dwSize-1);
end;


//--- Bits & Flags -------------------------------------------------------------

function IsFlagSet( dwTestForFlag, dwFlagSet : DWORD) : Boolean;
begin
  result := ((dwTestForFlag and dwFlagSet) = dwTestForFlag);
end;


procedure SetFlag( const dwThisFlag : DWORD; var dwFlagSet : DWORD; aSet : Boolean);
begin
  if aSet
  then dwFlagSet := dwFlagSet or dwThisFlag
  else dwFlagSet := dwFlagSet and not dwThisFlag;
end;



//--- ShellApi -----------------------------------------------------------------


function ShellRecycle( aWnd : HWND; aFileOrFolder : string) : Boolean;
var fop : SHFILEOPSTRUCT;
    sNm : string;
const FOF_WANTNUKEWARNING = $4000;  // erfordert Vista
begin
  // ASCIIZ-Liste, die Doppelnull terminiert, siehe MSDN
  // Use fully qualified names, otherwise not threadsafe
  sNm := ExpandFileName(aFileOrFolder) + #0#0;

  // Bestellzettel ausfüllen
  FillChar( fop, SizeOf(fop), 0);
  fop.Wnd      := aWnd;
  fop.wFunc    := FO_DELETE;
  fop.pFrom    := PChar(sNm);
  fop.fFlags   := FOF_ALLOWUNDO;  // or FOF_WANTNUKEWARNING;

  // die Bestellung aufgeben,
  result := (SHFileOperation(fop) = 0);
end;



//--- Debugging ----------------------------------------------------------------


function IsDebuggerPresent : BOOL;  stdcall;
external KERNEL32 name 'IsDebuggerPresent';


function NotImplemented : HRESULT;
// Aufruf einer nichtimplementierten Methode
begin
  result := E_NOTIMPL;
  {$IFDEF Debug}
  if IsDebuggerPresent
  then asm INT 3 end;
   {$ENDIF}
end;


end.
