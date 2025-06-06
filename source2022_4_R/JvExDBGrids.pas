{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExDBGrids.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas dott Hausladen att gmx dott de]
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvExDBGrids.pas 12645 2010-01-07 15:15:13Z ahuser $

unit JvExDBGrids;

{$I jvcl.inc}
{MACROINCLUDE JvExControls.macros}

{*****************************************************************************
 * WARNING: Do not edit this file.
 * This file is autogenerated from the source in devtools/JvExVCL/src.
 * If you do it despite this warning your changes will be discarded by the next
 * update of this file. Do your changes in the template files.
 ****************************************************************************}
{$D-} // do not step into this unit

interface

uses
  Windows, Messages, Types,
  SysUtils, Classes, Graphics, Controls, Forms, DBGrids,
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  JvConsts, JvTypes, JvThemes, JVCLVer, JvExControls;

type
  TJvExCustomDBGrid = class(TCustomDBGrid, IJvExControl)
  private
    FAboutJVCL: TJVCLAboutInfo;
    FHintColor: TColor;
    FMouseOver: Boolean;
    FHintWindowClass: THintWindowClass;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    function BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer; overload;
    function BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer; overload;
    function BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
  protected
    procedure WndProc(var Msg: TMessage); override;
    procedure FocusChanged(AControl: TWinControl); dynamic;
    procedure VisibleChanged; reintroduce; dynamic;
    procedure EnabledChanged; reintroduce; dynamic;
    procedure TextChanged; reintroduce; virtual;
    procedure ColorChanged; reintroduce; dynamic;
    procedure FontChanged; reintroduce; dynamic;
    procedure ParentFontChanged; reintroduce; dynamic;
    procedure ParentColorChanged; reintroduce; dynamic;
    procedure ParentShowHintChanged; reintroduce; dynamic;
    function WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean; reintroduce; virtual;
    function HintShow(var HintInfo: THintInfo): Boolean; reintroduce; dynamic;
    function HitTest(X, Y: Integer): Boolean; reintroduce; virtual;
    procedure MouseEnter(AControl: TControl); reintroduce; dynamic;
    procedure MouseLeave(AControl: TControl); reintroduce; dynamic;
    property MouseOver: Boolean read FMouseOver write FMouseOver;
    property HintColor: TColor read FHintColor write FHintColor default clDefault;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
  public
    constructor Create(AOwner: TComponent); override;
    property HintWindowClass: THintWindowClass read FHintWindowClass write FHintWindowClass;
  published
    property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
  private
    FDotNetHighlighting: Boolean;
  protected
    procedure BoundsChanged; reintroduce; virtual;
    procedure CursorChanged; reintroduce; dynamic;
    procedure ShowingChanged; reintroduce; dynamic;
    procedure ShowHintChanged; reintroduce; dynamic;
    procedure ControlsListChanging(Control: TControl; Inserting: Boolean); reintroduce; dynamic;
    procedure ControlsListChanged(Control: TControl; Inserting: Boolean); reintroduce; dynamic;
    procedure GetDlgCode(var Code: TDlgCodes); virtual;
    procedure FocusSet(PrevWnd: THandle); virtual;
    procedure FocusKilled(NextWnd: THandle); virtual;
    function DoEraseBackground(Canvas: TCanvas; Param: Integer): Boolean; virtual;
  {$IFDEF JVCLThemesEnabledD6}
  private
    function GetParentBackground: Boolean;
  protected
    procedure SetParentBackground(Value: Boolean); virtual;
    property ParentBackground: Boolean read GetParentBackground write SetParentBackground;
  {$ENDIF JVCLThemesEnabledD6}
  published
    property DotNetHighlighting: Boolean read FDotNetHighlighting write FDotNetHighlighting default False;
  end;

  TJvExDBGrid = class(TDBGrid, IJvExControl)
  private
    FAboutJVCL: TJVCLAboutInfo;
    FHintColor: TColor;
    FMouseOver: Boolean;
    FHintWindowClass: THintWindowClass;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    function BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer; overload;
    function BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer; overload;
    function BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
  protected
    procedure WndProc(var Msg: TMessage); override;
    procedure FocusChanged(AControl: TWinControl); dynamic;
    procedure VisibleChanged; reintroduce; dynamic;
    procedure EnabledChanged; reintroduce; dynamic;
    procedure TextChanged; reintroduce; virtual;
    procedure ColorChanged; reintroduce; dynamic;
    procedure FontChanged; reintroduce; dynamic;
    procedure ParentFontChanged; reintroduce; dynamic;
    procedure ParentColorChanged; reintroduce; dynamic;
    procedure ParentShowHintChanged; reintroduce; dynamic;
    function WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean; reintroduce; virtual;
    function HintShow(var HintInfo: THintInfo): Boolean; reintroduce; dynamic;
    function HitTest(X, Y: Integer): Boolean; reintroduce; virtual;
    procedure MouseEnter(AControl: TControl); reintroduce; dynamic;
    procedure MouseLeave(AControl: TControl); reintroduce; dynamic;
    property MouseOver: Boolean read FMouseOver write FMouseOver;
    property HintColor: TColor read FHintColor write FHintColor default clDefault;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
  public
    constructor Create(AOwner: TComponent); override;
    property HintWindowClass: THintWindowClass read FHintWindowClass write FHintWindowClass;
  published
    property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
  private
    FDotNetHighlighting: Boolean;
  protected
    procedure BoundsChanged; reintroduce; virtual;
    procedure CursorChanged; reintroduce; dynamic;
    procedure ShowingChanged; reintroduce; dynamic;
    procedure ShowHintChanged; reintroduce; dynamic;
    procedure ControlsListChanging(Control: TControl; Inserting: Boolean); reintroduce; dynamic;
    procedure ControlsListChanged(Control: TControl; Inserting: Boolean); reintroduce; dynamic;
    procedure GetDlgCode(var Code: TDlgCodes); virtual;
    procedure FocusSet(PrevWnd: THandle); virtual;
    procedure FocusKilled(NextWnd: THandle); virtual;
    function DoEraseBackground(Canvas: TCanvas; Param: Integer): Boolean; virtual;
  {$IFDEF JVCLThemesEnabledD6}
  private
    function GetParentBackground: Boolean;
  protected
    procedure SetParentBackground(Value: Boolean); virtual;
    property ParentBackground: Boolean read GetParentBackground write SetParentBackground;
  {$ENDIF JVCLThemesEnabledD6}
  published
    property DotNetHighlighting: Boolean read FDotNetHighlighting write FDotNetHighlighting default False;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_40_PREPARATION/run/JvExDBGrids.pas $';
    Revision: '$Revision: 12645 $';
    Date: '$Date: 2010-01-07 16:15:13 +0100 (jeu., 07 janv. 2010) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

constructor TJvExCustomDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHintColor := clDefault;
end;

function TJvExCustomDBGrid.BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer;
var
  Mesg: TMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExCustomDBGrid.BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer;
var
  Mesg: TMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExCustomDBGrid.BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
var
  Mesg: TStructPtrMessage;
begin
  Mesg := TStructPtrMessage.Create(Msg, WParam, LParam);
  try
    inherited WndProc(Mesg.Msg);
  finally
    Result := Mesg.Msg.Result;
    Mesg.Free;
  end;
end;

procedure TJvExCustomDBGrid.VisibleChanged;
begin
  BaseWndProc(CM_VISIBLECHANGED);
end;

procedure TJvExCustomDBGrid.EnabledChanged;
begin
  BaseWndProc(CM_ENABLEDCHANGED);
end;

procedure TJvExCustomDBGrid.TextChanged;
begin
  BaseWndProc(CM_TEXTCHANGED);
end;

procedure TJvExCustomDBGrid.FontChanged;
begin
  BaseWndProc(CM_FONTCHANGED);
end;

procedure TJvExCustomDBGrid.ColorChanged;
begin
  BaseWndProc(CM_COLORCHANGED);
end;

procedure TJvExCustomDBGrid.ParentFontChanged;
begin
  BaseWndProc(CM_PARENTFONTCHANGED);
end;

procedure TJvExCustomDBGrid.ParentColorChanged;
begin
  BaseWndProc(CM_PARENTCOLORCHANGED);
  if Assigned(OnParentColorChange) then
    OnParentColorChange(Self);
end;

procedure TJvExCustomDBGrid.ParentShowHintChanged;
begin
  BaseWndProc(CM_PARENTSHOWHINTCHANGED);
end;

function TJvExCustomDBGrid.WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean;
begin
  Result := BaseWndProc(CM_DIALOGCHAR, Word(Key), ShiftStateToKeyData(Shift)) <> 0;
end;

function TJvExCustomDBGrid.HitTest(X, Y: Integer): Boolean;
begin
  Result := BaseWndProc(CM_HITTEST, 0, SmallPointToLong(PointToSmallPoint(Point(X, Y)))) <> 0;
end;

function TJvExCustomDBGrid.HintShow(var HintInfo: THintInfo): Boolean;
begin
  GetHintColor(HintInfo, Self, FHintColor);
  if FHintWindowClass <> nil then
    HintInfo.HintWindowClass := FHintWindowClass;
  Result := BaseWndProcEx(CM_HINTSHOW, 0, HintInfo) <> 0;
end;

procedure TJvExCustomDBGrid.MouseEnter(AControl: TControl);
begin
  FMouseOver := True;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
  BaseWndProc(CM_MOUSEENTER, 0, AControl);
end;

procedure TJvExCustomDBGrid.MouseLeave(AControl: TControl);
begin
  FMouseOver := False;
  BaseWndProc(CM_MOUSELEAVE, 0, AControl);
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TJvExCustomDBGrid.FocusChanged(AControl: TWinControl);
begin
  BaseWndProc(CM_FOCUSCHANGED, 0, AControl);
end;

procedure TJvExCustomDBGrid.BoundsChanged;
begin
end;

procedure TJvExCustomDBGrid.CursorChanged;
begin
  BaseWndProc(CM_CURSORCHANGED);
end;

procedure TJvExCustomDBGrid.ShowingChanged;
begin
  BaseWndProc(CM_SHOWINGCHANGED);
end;

procedure TJvExCustomDBGrid.ShowHintChanged;
begin
  BaseWndProc(CM_SHOWHINTCHANGED);
end;

{ VCL sends CM_CONTROLLISTCHANGE and CM_CONTROLCHANGE in a different order than
  the CLX methods are used. So we must correct it by evaluating "Inserting". }
procedure TJvExCustomDBGrid.ControlsListChanging(Control: TControl; Inserting: Boolean);
begin
  if Inserting then
    BaseWndProc(CM_CONTROLLISTCHANGE, Integer(Control), Integer(Inserting))
  else
    BaseWndProc(CM_CONTROLCHANGE, Integer(Control), Integer(Inserting));
end;

procedure TJvExCustomDBGrid.ControlsListChanged(Control: TControl; Inserting: Boolean);
begin
  if not Inserting then
    BaseWndProc(CM_CONTROLLISTCHANGE, Integer(Control), Integer(Inserting))
  else
    BaseWndProc(CM_CONTROLCHANGE, Integer(Control), Integer(Inserting));
end;

procedure TJvExCustomDBGrid.GetDlgCode(var Code: TDlgCodes);
begin
end;

procedure TJvExCustomDBGrid.FocusSet(PrevWnd: THandle);
begin
  BaseWndProc(WM_SETFOCUS, Integer(PrevWnd), 0);
end;

procedure TJvExCustomDBGrid.FocusKilled(NextWnd: THandle);
begin
  BaseWndProc(WM_KILLFOCUS, Integer(NextWnd), 0);
end;

function TJvExCustomDBGrid.DoEraseBackground(Canvas: TCanvas; Param: Integer): Boolean;
begin
  Result := BaseWndProc(WM_ERASEBKGND, Canvas.Handle, Param) <> 0;
end;

{$IFDEF JVCLThemesEnabledD6}
function TJvExCustomDBGrid.GetParentBackground: Boolean;
begin
  Result := JvThemes.GetParentBackground(Self);
end;

procedure TJvExCustomDBGrid.SetParentBackground(Value: Boolean);
begin
  JvThemes.SetParentBackground(Self, Value);
end;
{$ENDIF JVCLThemesEnabledD6}

procedure TJvExCustomDBGrid.WndProc(var Msg: TMessage);
var
  IdSaveDC: Integer;
  DlgCodes: TDlgCodes;
  Canvas: TCanvas;
begin
  if not DispatchIsDesignMsg(Self, Msg) then
  begin
    case Msg.Msg of
      CM_DENYSUBCLASSING:
      Msg.Result := Ord(GetInterfaceEntry(IJvDenySubClassing) <> nil);
    CM_DIALOGCHAR:
      with TCMDialogChar{$IFDEF CLR}.Create{$ENDIF}(Msg) do
        Result := Ord(WantKey(CharCode, KeyDataToShiftState(KeyData), WideChar(CharCode)));
    CM_HINTSHOW:
      with TCMHintShow(Msg) do
        Result := Integer(HintShow(HintInfo^));
    CM_HITTEST:
      with TCMHitTest(Msg) do
        Result := Integer(HitTest(XPos, YPos));
    CM_MOUSEENTER:
      MouseEnter(TControl(Msg.LParam));
    CM_MOUSELEAVE:
      MouseLeave(TControl(Msg.LParam));
    CM_VISIBLECHANGED:
      VisibleChanged;
    CM_ENABLEDCHANGED:
      EnabledChanged;
    CM_TEXTCHANGED:
      TextChanged;
    CM_FONTCHANGED:
      FontChanged;
    CM_COLORCHANGED:
      ColorChanged;
    CM_FOCUSCHANGED:
      FocusChanged(TWinControl(Msg.LParam));
    CM_PARENTFONTCHANGED:
      ParentFontChanged;
    CM_PARENTCOLORCHANGED:
      ParentColorChanged;
    CM_PARENTSHOWHINTCHANGED:
      ParentShowHintChanged;
    CM_CURSORCHANGED:
      CursorChanged;
    CM_SHOWINGCHANGED:
      ShowingChanged;
    CM_SHOWHINTCHANGED:
      ShowHintChanged;
    CM_CONTROLLISTCHANGE:
      if Msg.LParam <> 0 then
        ControlsListChanging(TControl(Msg.WParam), True)
      else
        ControlsListChanged(TControl(Msg.WParam), False);
    CM_CONTROLCHANGE:
      if Msg.LParam = 0 then
        ControlsListChanging(TControl(Msg.WParam), False)
      else
        ControlsListChanged(TControl(Msg.WParam), True);
    WM_SETFOCUS:
      FocusSet(THandle(Msg.WParam));
    WM_KILLFOCUS:
      FocusKilled(THandle(Msg.WParam));
    WM_SIZE, WM_MOVE:
      begin
        inherited WndProc(Msg);
        BoundsChanged;
      end;
    WM_ERASEBKGND:
      if Msg.WParam <> 0 then
      begin
        IdSaveDC := SaveDC(HDC(Msg.WParam)); // protect DC against Stock-Objects from Canvas
        Canvas := TCanvas.Create;
        try
          Canvas.Handle := HDC(Msg.WParam);
          Msg.Result := Ord(DoEraseBackground(Canvas, Msg.LParam));
        finally
          Canvas.Handle := 0;
          Canvas.Free;
          RestoreDC(HDC(Msg.WParam), IdSaveDC);
        end;
      end
      else
        inherited WndProc(Msg);
    {$IFNDEF DELPHI2007_UP}
    WM_PRINTCLIENT, WM_PRINT: // VCL bug fix
      begin
        IdSaveDC := SaveDC(HDC(Msg.WParam)); // protect DC against changes
        try
          inherited WndProc(Msg);
        finally
          RestoreDC(HDC(Msg.WParam), IdSaveDC);
        end;
      end;
    {$ENDIF ~DELPHI2007_UP}
    WM_GETDLGCODE:
      begin
        inherited WndProc(Msg);
        DlgCodes := [dcNative] + DlgcToDlgCodes(Msg.Result);
        GetDlgCode(DlgCodes);
        if not (dcNative in DlgCodes) then
          Msg.Result := DlgCodesToDlgc(DlgCodes);
      end;
    else
      inherited WndProc(Msg);
    end;
    case Msg.Msg of // precheck message to prevent access violations on released controls
      CM_MOUSEENTER, CM_MOUSELEAVE, WM_KILLFOCUS, WM_SETFOCUS, WM_NCPAINT:
        if DotNetHighlighting then
          HandleDotNetHighlighting(Self, Msg, MouseOver, Color);
    end;
  end;
end;

//============================================================================

constructor TJvExDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHintColor := clDefault;
end;

function TJvExDBGrid.BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer;
var
  Mesg: TMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExDBGrid.BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer;
var
  Mesg: TMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExDBGrid.BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
var
  Mesg: TStructPtrMessage;
begin
  Mesg := TStructPtrMessage.Create(Msg, WParam, LParam);
  try
    inherited WndProc(Mesg.Msg);
  finally
    Result := Mesg.Msg.Result;
    Mesg.Free;
  end;
end;

procedure TJvExDBGrid.VisibleChanged;
begin
  BaseWndProc(CM_VISIBLECHANGED);
end;

procedure TJvExDBGrid.EnabledChanged;
begin
  BaseWndProc(CM_ENABLEDCHANGED);
end;

procedure TJvExDBGrid.TextChanged;
begin
  BaseWndProc(CM_TEXTCHANGED);
end;

procedure TJvExDBGrid.FontChanged;
begin
  BaseWndProc(CM_FONTCHANGED);
end;

procedure TJvExDBGrid.ColorChanged;
begin
  BaseWndProc(CM_COLORCHANGED);
end;

procedure TJvExDBGrid.ParentFontChanged;
begin
  BaseWndProc(CM_PARENTFONTCHANGED);
end;

procedure TJvExDBGrid.ParentColorChanged;
begin
  BaseWndProc(CM_PARENTCOLORCHANGED);
  if Assigned(OnParentColorChange) then
    OnParentColorChange(Self);
end;

procedure TJvExDBGrid.ParentShowHintChanged;
begin
  BaseWndProc(CM_PARENTSHOWHINTCHANGED);
end;

function TJvExDBGrid.WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean;
begin
  Result := BaseWndProc(CM_DIALOGCHAR, Word(Key), ShiftStateToKeyData(Shift)) <> 0;
end;

function TJvExDBGrid.HitTest(X, Y: Integer): Boolean;
begin
  Result := BaseWndProc(CM_HITTEST, 0, SmallPointToLong(PointToSmallPoint(Point(X, Y)))) <> 0;
end;

function TJvExDBGrid.HintShow(var HintInfo: THintInfo): Boolean;
begin
  GetHintColor(HintInfo, Self, FHintColor);
  if FHintWindowClass <> nil then
    HintInfo.HintWindowClass := FHintWindowClass;
  Result := BaseWndProcEx(CM_HINTSHOW, 0, HintInfo) <> 0;
end;

procedure TJvExDBGrid.MouseEnter(AControl: TControl);
begin
  FMouseOver := True;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
  BaseWndProc(CM_MOUSEENTER, 0, AControl);
end;

procedure TJvExDBGrid.MouseLeave(AControl: TControl);
begin
  FMouseOver := False;
  BaseWndProc(CM_MOUSELEAVE, 0, AControl);
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TJvExDBGrid.FocusChanged(AControl: TWinControl);
begin
  BaseWndProc(CM_FOCUSCHANGED, 0, AControl);
end;

procedure TJvExDBGrid.BoundsChanged;
begin
end;

procedure TJvExDBGrid.CursorChanged;
begin
  BaseWndProc(CM_CURSORCHANGED);
end;

procedure TJvExDBGrid.ShowingChanged;
begin
  BaseWndProc(CM_SHOWINGCHANGED);
end;

procedure TJvExDBGrid.ShowHintChanged;
begin
  BaseWndProc(CM_SHOWHINTCHANGED);
end;

{ VCL sends CM_CONTROLLISTCHANGE and CM_CONTROLCHANGE in a different order than
  the CLX methods are used. So we must correct it by evaluating "Inserting". }
procedure TJvExDBGrid.ControlsListChanging(Control: TControl; Inserting: Boolean);
begin
  if Inserting then
    BaseWndProc(CM_CONTROLLISTCHANGE, Integer(Control), Integer(Inserting))
  else
    BaseWndProc(CM_CONTROLCHANGE, Integer(Control), Integer(Inserting));
end;

procedure TJvExDBGrid.ControlsListChanged(Control: TControl; Inserting: Boolean);
begin
  if not Inserting then
    BaseWndProc(CM_CONTROLLISTCHANGE, Integer(Control), Integer(Inserting))
  else
    BaseWndProc(CM_CONTROLCHANGE, Integer(Control), Integer(Inserting));
end;

procedure TJvExDBGrid.GetDlgCode(var Code: TDlgCodes);
begin
end;

procedure TJvExDBGrid.FocusSet(PrevWnd: THandle);
begin
  BaseWndProc(WM_SETFOCUS, Integer(PrevWnd), 0);
end;

procedure TJvExDBGrid.FocusKilled(NextWnd: THandle);
begin
  BaseWndProc(WM_KILLFOCUS, Integer(NextWnd), 0);
end;

function TJvExDBGrid.DoEraseBackground(Canvas: TCanvas; Param: Integer): Boolean;
begin
  Result := BaseWndProc(WM_ERASEBKGND, Canvas.Handle, Param) <> 0;
end;

{$IFDEF JVCLThemesEnabledD6}
function TJvExDBGrid.GetParentBackground: Boolean;
begin
  Result := JvThemes.GetParentBackground(Self);
end;

procedure TJvExDBGrid.SetParentBackground(Value: Boolean);
begin
  JvThemes.SetParentBackground(Self, Value);
end;
{$ENDIF JVCLThemesEnabledD6}

procedure TJvExDBGrid.WndProc(var Msg: TMessage);
var
  IdSaveDC: Integer;
  DlgCodes: TDlgCodes;
  Canvas: TCanvas;
begin
  if not DispatchIsDesignMsg(Self, Msg) then
  begin
    case Msg.Msg of
      CM_DENYSUBCLASSING:
      Msg.Result := Ord(GetInterfaceEntry(IJvDenySubClassing) <> nil);
    CM_DIALOGCHAR:
      with TCMDialogChar{$IFDEF CLR}.Create{$ENDIF}(Msg) do
        Result := Ord(WantKey(CharCode, KeyDataToShiftState(KeyData), WideChar(CharCode)));
    CM_HINTSHOW:
      with TCMHintShow(Msg) do
        Result := Integer(HintShow(HintInfo^));
    CM_HITTEST:
      with TCMHitTest(Msg) do
        Result := Integer(HitTest(XPos, YPos));
    CM_MOUSEENTER:
      MouseEnter(TControl(Msg.LParam));
    CM_MOUSELEAVE:
      MouseLeave(TControl(Msg.LParam));
    CM_VISIBLECHANGED:
      VisibleChanged;
    CM_ENABLEDCHANGED:
      EnabledChanged;
    CM_TEXTCHANGED:
      TextChanged;
    CM_FONTCHANGED:
      FontChanged;
    CM_COLORCHANGED:
      ColorChanged;
    CM_FOCUSCHANGED:
      FocusChanged(TWinControl(Msg.LParam));
    CM_PARENTFONTCHANGED:
      ParentFontChanged;
    CM_PARENTCOLORCHANGED:
      ParentColorChanged;
    CM_PARENTSHOWHINTCHANGED:
      ParentShowHintChanged;
    CM_CURSORCHANGED:
      CursorChanged;
    CM_SHOWINGCHANGED:
      ShowingChanged;
    CM_SHOWHINTCHANGED:
      ShowHintChanged;
    CM_CONTROLLISTCHANGE:
      if Msg.LParam <> 0 then
        ControlsListChanging(TControl(Msg.WParam), True)
      else
        ControlsListChanged(TControl(Msg.WParam), False);
    CM_CONTROLCHANGE:
      if Msg.LParam = 0 then
        ControlsListChanging(TControl(Msg.WParam), False)
      else
        ControlsListChanged(TControl(Msg.WParam), True);
    WM_SETFOCUS:
      FocusSet(THandle(Msg.WParam));
    WM_KILLFOCUS:
      FocusKilled(THandle(Msg.WParam));
    WM_SIZE, WM_MOVE:
      begin
        inherited WndProc(Msg);
        BoundsChanged;
      end;
    WM_ERASEBKGND:
      if Msg.WParam <> 0 then
      begin
        IdSaveDC := SaveDC(HDC(Msg.WParam)); // protect DC against Stock-Objects from Canvas
        Canvas := TCanvas.Create;
        try
          Canvas.Handle := HDC(Msg.WParam);
          Msg.Result := Ord(DoEraseBackground(Canvas, Msg.LParam));
        finally
          Canvas.Handle := 0;
          Canvas.Free;
          RestoreDC(HDC(Msg.WParam), IdSaveDC);
        end;
      end
      else
        inherited WndProc(Msg);
    {$IFNDEF DELPHI2007_UP}
    WM_PRINTCLIENT, WM_PRINT: // VCL bug fix
      begin
        IdSaveDC := SaveDC(HDC(Msg.WParam)); // protect DC against changes
        try
          inherited WndProc(Msg);
        finally
          RestoreDC(HDC(Msg.WParam), IdSaveDC);
        end;
      end;
    {$ENDIF ~DELPHI2007_UP}
    WM_GETDLGCODE:
      begin
        inherited WndProc(Msg);
        DlgCodes := [dcNative] + DlgcToDlgCodes(Msg.Result);
        GetDlgCode(DlgCodes);
        if not (dcNative in DlgCodes) then
          Msg.Result := DlgCodesToDlgc(DlgCodes);
      end;
    else
      inherited WndProc(Msg);
    end;
    case Msg.Msg of // precheck message to prevent access violations on released controls
      CM_MOUSEENTER, CM_MOUSELEAVE, WM_KILLFOCUS, WM_SETFOCUS, WM_NCPAINT:
        if DotNetHighlighting then
          HandleDotNetHighlighting(Self, Msg, MouseOver, Color);
    end;
  end;
end;

//============================================================================

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.