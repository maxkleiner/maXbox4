{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvWin32.pas, released on 2005-10-29.

The Initial Developer of the Original Code is:
Robert Marquardt (robert_marquardt att gmx dott de)
Copyright (c) 2005 Robert Marquardt
All Rights Reserved.

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvWin32.pas 12461 2009-08-14 17:21:33Z obones $

unit JvWin32;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  CommCtrl, Windows;

const
  SC_DRAGMOVE = $F012;

  {$IFNDEF COMPILER7_UP}
  SPI_GETFLATMENU = $1022;
  {$EXTERNALSYM SPI_GETFLATMENU}
  {$ENDIF ~COMPILER7_UP}

  {$IFNDEF COMPILER7_UP}
  SM_XVIRTUALSCREEN = 76;
  {$EXTERNALSYM SM_XVIRTUALSCREEN}
  SM_YVIRTUALSCREEN = 77;
  {$EXTERNALSYM SM_YVIRTUALSCREEN}
  SM_CXVIRTUALSCREEN = 78;
  {$EXTERNALSYM SM_CXVIRTUALSCREEN}
  SM_CYVIRTUALSCREEN = 79;
  {$EXTERNALSYM SM_CYVIRTUALSCREEN}
  {$ENDIF !COMPILER7_UP}

  CS_DROPSHADOW = $00020000;
  {$IFDEF DELPHI11_UP}
  {$EXTERNALSYM CS_DROPSHADOW}
  {$ENDIF DELPHI11_UP}

  //==========================================================================
  {$IFDEF VCL}
  TVM_SETLINECOLOR = TV_FIRST + 40;
  {$EXTERNALSYM TVM_SETLINECOLOR}
  TVM_GETLINECOLOR = TV_FIRST + 41;
  {$EXTERNALSYM TVM_GETLINECOLOR}
  {$ENDIF VCL}

  //==========================================================================
  { Taken from WinNT.h }
  FILE_ATTRIBUTE_SPARSE_FILE = $200;
  {$EXTERNALSYM FILE_ATTRIBUTE_SPARSE_FILE}

  FILE_ATTRIBUTE_REPARSE_POINT = $400;
  {$EXTERNALSYM FILE_ATTRIBUTE_REPARSE_POINT}

  FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = $2000;
  {$EXTERNALSYM FILE_ATTRIBUTE_NOT_CONTENT_INDEXED}

  FILE_ATTRIBUTE_ENCRYPTED = $4000;
  {$EXTERNALSYM FILE_ATTRIBUTE_ENCRYPTED}

  //==========================================================================
  FOF_NOCOPYSECURITYATTRIBS = $800;
  {$EXTERNALSYM FOF_NOCOPYSECURITYATTRIBS}
  FOF_NORECURSION = $1000;
  {$EXTERNALSYM FOF_NORECURSION}
  // IE 5 and up
  FOF_NO_CONNECTED_ELEMENTS = $2000;
  {$EXTERNALSYM FOF_NO_CONNECTED_ELEMENTS}
  // IE 5.01 and up
  FOF_NORECURSEREPARSE = $8000;
  {$EXTERNALSYM FOF_NORECURSEREPARSE}
  FOF_WANTNUKEWARNING = $4000;
  {$EXTERNALSYM FOF_WANTNUKEWARNING}

  //==========================================================================
  HSHELL_WINDOWCREATED = 1;
  {$EXTERNALSYM HSHELL_WINDOWCREATED}
  HSHELL_WINDOWDESTROYED = 2;
  {$EXTERNALSYM HSHELL_WINDOWDESTROYED}
  HSHELL_ACTIVATESHELLWINDOW = 3;
  {$EXTERNALSYM HSHELL_ACTIVATESHELLWINDOW}

  HSHELL_WINDOWACTIVATED = 4;
  {$EXTERNALSYM HSHELL_WINDOWACTIVATED}
  HSHELL_GETMINRECT = 5;
  {$EXTERNALSYM HSHELL_GETMINRECT}
  HSHELL_REDRAW = 6;
  {$EXTERNALSYM HSHELL_REDRAW}
  HSHELL_TASKMAN = 7;
  {$EXTERNALSYM HSHELL_TASKMAN}
  HSHELL_LANGUAGE = 8;
  {$EXTERNALSYM HSHELL_LANGUAGE}
  HSHELL_SYSMENU = 9;
  {$EXTERNALSYM HSHELL_SYSMENU}
  HSHELL_ENDTASK = 10;
  {$EXTERNALSYM HSHELL_ENDTASK}
  HSHELL_ACCESSIBILITYSTATE = 11;
  {$EXTERNALSYM HSHELL_ACCESSIBILITYSTATE}
  HSHELL_APPCOMMAND = 12;
  {$EXTERNALSYM HSHELL_APPCOMMAND}
  HSHELL_WINDOWREPLACED = 13;
  {$EXTERNALSYM HSHELL_WINDOWREPLACED}
  HSHELL_WINDOWREPLACING = 14;
  {$EXTERNALSYM HSHELL_WINDOWREPLACING}

  HSHELL_HIGHBIT = $8000;
  {$EXTERNALSYM HSHELL_HIGHBIT}
  HSHELL_FLASH = (HSHELL_REDRAW or HSHELL_HIGHBIT);
  {$EXTERNALSYM HSHELL_FLASH}
  HSHELL_RUDEAPPACTIVATED = (HSHELL_WINDOWACTIVATED or HSHELL_HIGHBIT);
  {$EXTERNALSYM HSHELL_RUDEAPPACTIVATED}

  (* wparam for HSHELL_ACCESSIBILITYSTATE *)
  ACCESS_STICKYKEYS = $0001;
  {$EXTERNALSYM ACCESS_STICKYKEYS}
  ACCESS_FILTERKEYS = $0002;
  {$EXTERNALSYM ACCESS_FILTERKEYS}
  ACCESS_MOUSEKEYS = $0003;
  {$EXTERNALSYM ACCESS_MOUSEKEYS}

  (* cmd for HSHELL_APPCOMMAND and WM_APPCOMMAND *)
  APPCOMMAND_BROWSER_BACKWARD = 1;
  {$EXTERNALSYM APPCOMMAND_BROWSER_BACKWARD}
  APPCOMMAND_BROWSER_FORWARD = 2;
  {$EXTERNALSYM APPCOMMAND_BROWSER_FORWARD}
  APPCOMMAND_BROWSER_REFRESH = 3;
  {$EXTERNALSYM APPCOMMAND_BROWSER_REFRESH}
  APPCOMMAND_BROWSER_STOP = 4;
  {$EXTERNALSYM APPCOMMAND_BROWSER_STOP}
  APPCOMMAND_BROWSER_SEARCH = 5;
  {$EXTERNALSYM APPCOMMAND_BROWSER_SEARCH}
  APPCOMMAND_BROWSER_FAVORITES = 6;
  {$EXTERNALSYM APPCOMMAND_BROWSER_FAVORITES}
  APPCOMMAND_BROWSER_HOME = 7;
  {$EXTERNALSYM APPCOMMAND_BROWSER_HOME}
  APPCOMMAND_VOLUME_MUTE = 8;
  {$EXTERNALSYM APPCOMMAND_VOLUME_MUTE}
  APPCOMMAND_VOLUME_DOWN = 9;
  {$EXTERNALSYM APPCOMMAND_VOLUME_DOWN}
  APPCOMMAND_VOLUME_UP = 10;
  {$EXTERNALSYM APPCOMMAND_VOLUME_UP}
  APPCOMMAND_MEDIA_NEXTTRACK = 11;
  {$EXTERNALSYM APPCOMMAND_MEDIA_NEXTTRACK}
  APPCOMMAND_MEDIA_PREVIOUSTRACK = 12;
  {$EXTERNALSYM APPCOMMAND_MEDIA_PREVIOUSTRACK}
  APPCOMMAND_MEDIA_STOP = 13;
  {$EXTERNALSYM APPCOMMAND_MEDIA_STOP}
  APPCOMMAND_MEDIA_PLAY_PAUSE = 14;
  {$EXTERNALSYM APPCOMMAND_MEDIA_PLAY_PAUSE}
  APPCOMMAND_LAUNCH_MAIL = 15;
  {$EXTERNALSYM APPCOMMAND_LAUNCH_MAIL}
  APPCOMMAND_LAUNCH_MEDIA_SELECT = 16;
  {$EXTERNALSYM APPCOMMAND_LAUNCH_MEDIA_SELECT}
  APPCOMMAND_LAUNCH_APP1 = 17;
  {$EXTERNALSYM APPCOMMAND_LAUNCH_APP1}
  APPCOMMAND_LAUNCH_APP2 = 18;
  {$EXTERNALSYM APPCOMMAND_LAUNCH_APP2}
  APPCOMMAND_BASS_DOWN = 19;
  {$EXTERNALSYM APPCOMMAND_BASS_DOWN}
  APPCOMMAND_BASS_BOOST = 20;
  {$EXTERNALSYM APPCOMMAND_BASS_BOOST}
  APPCOMMAND_BASS_UP = 21;
  {$EXTERNALSYM APPCOMMAND_BASS_UP}
  APPCOMMAND_TREBLE_DOWN = 22;
  {$EXTERNALSYM APPCOMMAND_TREBLE_DOWN}
  APPCOMMAND_TREBLE_UP = 23;
  {$EXTERNALSYM APPCOMMAND_TREBLE_UP}
  APPCOMMAND_MICROPHONE_VOLUME_MUTE = 24;
  {$EXTERNALSYM APPCOMMAND_MICROPHONE_VOLUME_MUTE}
  APPCOMMAND_MICROPHONE_VOLUME_DOWN = 25;
  {$EXTERNALSYM APPCOMMAND_MICROPHONE_VOLUME_DOWN}
  APPCOMMAND_MICROPHONE_VOLUME_UP = 26;
  {$EXTERNALSYM APPCOMMAND_MICROPHONE_VOLUME_UP}
  APPCOMMAND_HELP = 27;
  {$EXTERNALSYM APPCOMMAND_HELP}
  APPCOMMAND_FIND = 28;
  {$EXTERNALSYM APPCOMMAND_FIND}
  APPCOMMAND_NEW = 29;
  {$EXTERNALSYM APPCOMMAND_NEW}
  APPCOMMAND_OPEN = 30;
  {$EXTERNALSYM APPCOMMAND_OPEN}
  APPCOMMAND_CLOSE = 31;
  {$EXTERNALSYM APPCOMMAND_CLOSE}
  APPCOMMAND_SAVE = 32;
  {$EXTERNALSYM APPCOMMAND_SAVE}
  APPCOMMAND_PRINT = 33;
  {$EXTERNALSYM APPCOMMAND_PRINT}
  APPCOMMAND_UNDO = 34;
  {$EXTERNALSYM APPCOMMAND_UNDO}
  APPCOMMAND_REDO = 35;
  {$EXTERNALSYM APPCOMMAND_REDO}
  APPCOMMAND_COPY = 36;
  {$EXTERNALSYM APPCOMMAND_COPY}
  APPCOMMAND_CUT = 37;
  {$EXTERNALSYM APPCOMMAND_CUT}
  APPCOMMAND_PASTE = 38;
  {$EXTERNALSYM APPCOMMAND_PASTE}
  APPCOMMAND_REPLY_TO_MAIL = 39;
  {$EXTERNALSYM APPCOMMAND_REPLY_TO_MAIL}
  APPCOMMAND_FORWARD_MAIL = 40;
  {$EXTERNALSYM APPCOMMAND_FORWARD_MAIL}
  APPCOMMAND_SEND_MAIL = 41;
  {$EXTERNALSYM APPCOMMAND_SEND_MAIL}
  APPCOMMAND_SPELL_CHECK = 42;
  {$EXTERNALSYM APPCOMMAND_SPELL_CHECK}
  APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE = 43;
  {$EXTERNALSYM APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE}
  APPCOMMAND_MIC_ON_OFF_TOGGLE = 44;
  {$EXTERNALSYM APPCOMMAND_MIC_ON_OFF_TOGGLE}
  APPCOMMAND_CORRECTION_LIST = 45;
  {$EXTERNALSYM APPCOMMAND_CORRECTION_LIST}
  APPCOMMAND_MEDIA_PLAY = 46;
  {$EXTERNALSYM APPCOMMAND_MEDIA_PLAY}
  APPCOMMAND_MEDIA_PAUSE = 47;
  {$EXTERNALSYM APPCOMMAND_MEDIA_PAUSE}
  APPCOMMAND_MEDIA_RECORD = 48;
  {$EXTERNALSYM APPCOMMAND_MEDIA_RECORD}
  APPCOMMAND_MEDIA_FAST_FORWARD = 49;
  {$EXTERNALSYM APPCOMMAND_MEDIA_FAST_FORWARD}
  APPCOMMAND_MEDIA_REWIND = 50;
  {$EXTERNALSYM APPCOMMAND_MEDIA_REWIND}
  APPCOMMAND_MEDIA_CHANNEL_UP = 51;
  {$EXTERNALSYM APPCOMMAND_MEDIA_CHANNEL_UP}
  APPCOMMAND_MEDIA_CHANNEL_DOWN = 52;
  {$EXTERNALSYM APPCOMMAND_MEDIA_CHANNEL_DOWN}

  FAPPCOMMAND_MOUSE = $8000;
  {$EXTERNALSYM FAPPCOMMAND_MOUSE}
  FAPPCOMMAND_KEY = 0;
  {$EXTERNALSYM FAPPCOMMAND_KEY}
  FAPPCOMMAND_OEM = $1000;
  {$EXTERNALSYM FAPPCOMMAND_OEM}
  FAPPCOMMAND_MASK = $F000;
  {$EXTERNALSYM FAPPCOMMAND_MASK}

function GET_APPCOMMAND_LPARAM(lParam: Integer): Word;
{$EXTERNALSYM GET_APPCOMMAND_LPARAM}
function GET_DEVICE_LPARAM(lParam: Integer): Word;
{$EXTERNALSYM GET_DEVICE_LPARAM}
function GET_MOUSEORKEY_LPARAM(lParam: Integer): Integer;
{$EXTERNALSYM GET_MOUSEORKEY_LPARAM}
function GET_FLAGS_LPARAM(lParam: Integer): Word;
{$EXTERNALSYM GET_FLAGS_LPARAM}
function GET_KEYSTATE_LPARAM(lParam: Integer): Word;
{$EXTERNALSYM GET_KEYSTATE_LPARAM}

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_40_PREPARATION/run/JvWin32.pas $';
    Revision: '$Revision: 12461 $';
    Date: '$Date: 2009-08-14 19:21:33 +0200 (ven., 14 août 2009) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

// converted macros

function GET_APPCOMMAND_LPARAM(lParam: Integer): Word;
begin
  Result := HiWord(lParam) and not FAPPCOMMAND_MASK;
end;

function GET_DEVICE_LPARAM(lParam: Integer): Word;
begin
  Result := HiWord(lParam) and FAPPCOMMAND_MASK;
end;

function GET_MOUSEORKEY_LPARAM(lParam: Integer): Integer;
begin
  Result := GET_DEVICE_LPARAM(lParam);
end;

function GET_FLAGS_LPARAM(lParam: Integer): Word;
begin
  Result := LoWord(lParam);
end;

function GET_KEYSTATE_LPARAM(lParam: Integer): Word;
begin
  Result := GET_FLAGS_LPARAM(lParam);
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
