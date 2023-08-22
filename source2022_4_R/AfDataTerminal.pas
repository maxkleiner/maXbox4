{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Terminal component with connection to data dispatcher              |
|==============================================================================|
| The contents of this file are subject to the Mozilla Public License Ver. 1.0 |
| (the "License"); you may not use this file except in compliance with the     |
| License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ |
|                                                                              |
| Software distributed under the License is distributed on an "AS IS" basis,   |
| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for |
| the specific language governing rights and limitations under the License.    |
|==============================================================================|
| The Original Code is AsyncFree Library.                                      |
|==============================================================================|
| The Initial Developer of the Original Code is Petr Vones (Czech Republic).   |
| Portions created by Petr Vones are Copyright (C) 1998, 1999.                 |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History:                                                                     |
|   see AfRegister.pas                                                         |
|==============================================================================}

unit AfDataTerminal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AfViewers, AfDataDispatcher;

type
  TAfDataTerminal = class(TAfCustomTerminal)
  private
    FActive: Boolean;
    FDataLink: TAfDataDispatcherLink;
    function GetDispatcher: TAfCustomDataDispatcher;
    procedure SetDispatcher(const Value: TAfCustomDataDispatcher);
    procedure OnNotify(Sender: TObject; EventKind: TAfDispEventKind);
  protected
    procedure KeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property BufferLine;
    property BufferLineNumber;
    property Canvas;
    property ColorTable;
    property FocusedPoint;
    property RelLineColors;
    property SelectedText;
    property SelStart;
    property SelEnd;
    property ScrollBackMode;
    property TermColor;
    property TopLeft;
    property UserData;
    property UseScroll;
  published
    property Active: Boolean read FActive write FActive default True;
    property Align;
    property AutoScrollBack;
    property BkSpcMode;
    property BorderStyle;
    property CaretBlinkTime;
    property Color;
    property Dispatcher: TAfCustomDataDispatcher read GetDispatcher write SetDispatcher;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property LeftSpace;
    property Logging;
    property LogFlushTime;
    property LogName;
    property LogSize;
    property MaxLineLength;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property SelectedColor;
    property SelectedStyle;
    property SelectedTextColor;
    property ScrollBackCaret;
    property ScrollBackKey;
    property ScrollBackRows;
    property ShowHint;
    property TabOrder;
    property TerminalCaret;
    property TermColorMode;
    property UserDataSize;
    property Visible;
    property OnBeepChar;
    property OnBof;
    property OnCursorChange;
    property OnDblClick;
    property OnDrawBuffer;
    property OnDrawLeftSpace;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnEof;
    property OnExit;
    property OnFlushLog;
    property OnFontChanged;
    property OnGetColors;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLeftSpaceMouseDown;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnNewLine;
    property OnProcessChar;
    property OnScrBckBufChange;
    property OnScrBckModeChange;
    property OnSelectionChange;
    property OnStartDrag;
    property OnUserDataChange;
  end;

implementation

{ TAfDataTerminal }

constructor TAfDataTerminal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive := True;
  FDataLink := TAfDataDispatcherLink.Create;
  FDataLink.OnNotify := OnNotify;
end;

destructor TAfDataTerminal.Destroy;
begin
  FDataLink.Free;
  inherited Destroy;
end;

function TAfDataTerminal.GetDispatcher: TAfCustomDataDispatcher;
begin
  Result := FDataLink.Dispatcher;
end;

procedure TAfDataTerminal.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FActive and (Dispatcher <> nil) then Dispatcher.WriteChar(Key);
end;

procedure TAfDataTerminal.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = Dispatcher) then
    Dispatcher := nil;
end;

procedure TAfDataTerminal.OnNotify(Sender: TObject; EventKind: TAfDispEventKind);
begin
  case EventKind of
    deClear:
      ClearBuffer;
    deData:
      if FActive then WriteString(FDataLink.Dispatcher.ReadString);
  end;
end;

procedure TAfDataTerminal.SetDispatcher(const Value: TAfCustomDataDispatcher);
begin
  FDataLink.Dispatcher := Value;
end;

end.
