{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvTypes.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse@buypin.com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s):
Michael Beck [mbeck@bigfoot.com].
Peter Thornqvist
Oliver Giesen

Last Modified: 2000-02-28

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
  (rom) all types from a single file should be put back in their file
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvTypes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls;

const
  MaxPixelCount = 32768;
  // (rom) unused
  {$IFDEF COMPILER7_UP}
  // (rom) is this correct?
  DEFAULT_SYSCOLOR_MASK = $000000FF;
  {$ELSE}
  DEFAULT_SYSCOLOR_MASK = $80000000;
  {$ENDIF}

type
  {$IFNDEF COMPILER5_UP}
  TAnchorKind = (akLeft, akTop, akRight, akBottom);
  TAnchors = set of TAnchorKind;
  {$ENDIF}
  // base JVCL Exception class to derive from
  EJVCLException = class(Exception);
  TOnLinkClick = procedure(Sender: TObject; Link: string) of object;
  TOnRegistryChangeKey = procedure(Sender: TObject; RootKey: HKEY; Path: string) of object;
  TLabelDirection = (sdLeftToRight, sdRightToLeft);
  TAngle = 0..360;
  TDirection = (drFromLeft, drFromRight, drFromTop, drFromBottom);
  TJvOutputMode = (omFile, omStream);
  TOnDoneFile = procedure(Sender: TObject; FileName: string; FileSize: Integer; Url: string) of object;
  TOnDoneStream = procedure(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string) of object;
  TOnProgress = procedure(Sender: TObject; Position: Integer; TotalSize: Integer; Url: string;
    var Continue: Boolean) of object;
  TOnFtpProgress = procedure(Sender: TObject; Position: Integer; Url: string) of object;

  PRGBArray = ^TRGBArray;
  TRGBArray = array [0..MaxPixelCount - 1] of TRGBTriple;
  TBalance = 0..100;
  TVolumeRec = record
    case Byte of
      0:
      (LongVolume: Longint);
      1:
      (LeftVolume,
        RightVolume: Word);
  end;
  { (rom) unused
  TPeaks = record
    Left: Integer;
    Right: Integer;
    LeftShifted: Integer;
    RightShifted: Integer;
  end;
  }

  TOnError = procedure(Sender: TObject; ErrorMsg: string) of object;
  TWallpaperStyle = (wpTile, wpCenter, wpStretch);
  TTransformationKind = (ttWipeLeft, ttWipeRight, ttWipeUp, ttWipeDown,
    ttTurnLeft, ttTurnRight, ttTurnUp, ttTurnDown,
    ttWipeDownRight, ttWipeDownLeft, ttWipeUpRight, ttWipeUpLeft);
  TJvWaveLocation = (frFile, frResource, frRAM);

  TPopupPosition = (ppNone, pppForm, ppApplication);
  TJvDirMask = (dmFileNameChange, dmDirnameChange, dmAttributesChange, dmSizeChange, dmLastWriteChange,
    dmSecurityChange);
  TJvDirMasks = set of TJvDirMask;
  EJvDirectoryError = class(EJVCLException);
  TListEvent = procedure(Sender: TObject; Title: string; Handle: THandle) of object;

  TOnPrintProgress = procedure(Sender: TObject; Current, Total: Integer) of object;
  TOnNextPage = procedure(Sender: TObject; PageNumber: Integer) of object;
  TBitmapStyle = (bsNormal, bsCentered, bsStretched);

  TOnOpened = procedure(Sender: TObject; Value: string) of object;
  TOnOpenCanceled = procedure(Sender: TObject) of object;

  TOnKeyFound = procedure(Sender: TObject; Key, Results, OriginalLine: string) of object;
  TParserInfos = TStringList;
  TParserInf = class
    StartTag: string;
    EndTag: string;
    MustBe: Integer;
    TakeText: Integer;
  end;

  const
    CrLf = #13#10;
    Cr = #13;
    Lf = #10;

type
  TGradStyle = (grFilled, grEllipse, grHorizontal, grVertical, grPyramid, grMount);
  TOnDelete = procedure(Sender: TObject; Path: string) of object;
  TOnParent = procedure(Sender: TObject; ParentWindow: THandle) of object;
  TOnImage = procedure(Sender: TObject; Image: TBitmap) of object;
  TOnText = procedure(Sender: TObject; Text: string) of object;
  TJvRestart = (rsLogoff, rsShutdown, rsReboot, rsRestart, rsRebootSystem, rsExitAndExecApp);
  TJvRunOption = (roNoBrowse, roNoDefault, roCalcDirectory, roNoLabel, roNoSeparateMem);
  TJvRunOptions = set of TJvRunOption;
  TJvFileKind = (ftFile, ftPrinter);

  TSHFormatDrive = function(Handle: HWND; Drive, ID, Options: Word): LongInt; stdcall;
  TFormatOption = (shQuickFormat, shFull, shSystemFilesOnly);
  TButtonStyle = (bsAbortRetryIgnore, bsOk, bsOkCancel, bsRetryCancel, bsYesNo, bsYesNoCancel);
  TButtonDisplay = (bdIconExclamation, bdIconWarning, bdIconInformation, bdIconAsterisk,
    bdIconQuestion, bdIconStop, bdIconError, bdIconHand);
  TDefault = (dbButton1, dbButton2, dbButton3, dbButton4);
  TModality = (bmApplModal, bmSystemModal, bmTaskModal);
  TButtonOption = (boDefaultDesktopOnly, boHelp, boRight, boRtlReading, boSetForeground, boTopMost);
  TButtonOptions = set of TButtonOption;
  TButtonResult = (brAbort, brCancel, brIgnore, brNo, brOk, brRetry, brYes);
  TMsgStyle = (msBeep, msIconAsterisk, msIconExclamation, msIconHand, msIconQuestion, msOk);
  TDiskRes = (dsSuccess, dsCancel, dsSkipfile, dsError);
  TDiskStyle = (idfCheckFirst, idfNoBeep, idfNoBrowse, idfNoCompressed, idfNoDetails,
    idfNoForeground, idfNoSkip, idfOemDisk, idfWarnIfSkip);
  TDiskStyles = set of TDiskStyle;
  TDeleteStyle = (idNoBeep, idNoForeground);
  TDeleteStyles = set of TDeleteStyle;
  TOnOk = procedure(Sender: TObject; Password: string; var Accept: Boolean) of object;

  TCoordChanged = procedure(Sender: TObject; Coord: string) of object;
  TNotifyEventParams = procedure(Sender: TObject; params: Pointer) of object;
  TFileInformation = record
    Attributes: DWORD;
    DisplayName: string;
    ExeType: Integer;
    Icon: HICON;
    Location: string;
    TypeName: string;
    SysIconIndex: Integer;
  end;
  TJvAnimations = (anLeftRight, anRightLeft, anRightAndLeft, anLeftVumeter, anRightVumeter);
  TJvAnimation = set of TJvAnimations;
  TDropEvent = procedure(Sender: TObject; Pos: TPoint; Value: TStringList) of object;
  TOnFound = procedure(Sender: TObject; Path: string) of object;
  TOnChangedDir = procedure(Sender: TObject; Directory: string) of object;
  TOnAlarm = procedure(Sender: TObject; Keyword: string) of object;
  TAlarm = record
    Keyword: string;
    DateTime: TDateTime;
  end;

  TFourCC = array [0..3] of Char;

  PAniTag = ^TAniTag;
  TAniTag = packed record
    ckID: TFourCC;
    ckSize: Longint;
  end;

  TAniHeader = record
    dwSizeof: Longint;
    dwFrames: Longint;
    dwSteps: Longint;
    dwCX: Longint;
    dwCY: Longint;
    dwBitCount: Longint;
    dwPlanes: Longint;
    dwJIFRate: Longint;
    dwFlags: Longint;
  end;

  TOnChangeColor = procedure(Sender: TObject; Foreground, Background: TColor) of object;

  TJvLayout = (lTop, lCenter, lBottom);
  TJvBevelStyle = (bsShape, bsLowered, bsRaised);

  {for OnLoseFocus the AFocusControl argument will point at the control that
   receives focus while for OnGetFocus it is the control that lost the focus}
  TJvFocusChangeEvent = procedure(const ASender: TObject;
    const AFocusControl: TWinControl) of object;

implementation

end.

