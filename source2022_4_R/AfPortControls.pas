{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Controls for selecting serial port                                 |
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

unit AfPortControls;

interface

{$I PVDEFINE.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AfComPort;

type
  TAfPortCtlOptions = set of (pcCheckExist, pcDisableOpen, pcHighlightOpen);

  TAfPortComboBox = class(TCustomComboBox)
  private
    FComPort: TAfComPort;
    FComNumber: Word;
    FOptions: TAfPortCtlOptions;
    FMaxComPorts: SmallInt;
    function GetNumberFromItem(I: Integer): Word;
    procedure SetComPort(const Value: TAfComPort);
    procedure SetComNumber(const Value: Word);
    procedure SetMaxComPorts(const Value: SmallInt);
    procedure UpdateItemIndex;
    procedure CMFontChanged(var Msg: TMessage); message CM_FONTCHANGED;
    procedure SetOptions(const Value: TAfPortCtlOptions);
  protected
    procedure BuildPortList;
    procedure Change; override;
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    property ComNumber: Word read FComNumber write SetComNumber;
  published
    property ComPort: TAfComPort read FComPort write SetComPort;
    property Options: TAfPortCtlOptions read FOptions write SetOptions default [pcCheckExist];
    property MaxComPorts: SmallInt read FMaxComPorts write SetMaxComPorts default 4;
{$IFDEF PV_D4UP}
    property Anchors;
{$ENDIF}
    property Color;
    property Ctl3D;
    property DropDownCount;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TAfPortRadioGroup = class(TCustomRadioGroup)
  private
    ButtonsList: TList;
    FComPort: TAfComPort;
    FComNumber: Word;
    FMaxComPorts: SmallInt;
    FOptions: TAfPortCtlOptions;
    procedure SetComPort(const Value: TAfComPort);
    procedure SetComNumber(const Value: Word);
    procedure SetMaxComPorts(const Value: SmallInt);
    procedure UpdateSelectedPort;
    procedure CMFontChanged(var Msg: TMessage); message CM_FONTCHANGED;
    procedure SetOptions(const Value: TAfPortCtlOptions);
  protected
    procedure BuildPortList(AlwaysCreate, UpdatePortState: Boolean);
    procedure Click; override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    property ComNumber: Word read FComNumber write SetComNumber;
    procedure UpdatePortList;
  published
    property ComPort: TAfComPort read FComPort write SetComPort;
    property MaxComPorts: SmallInt read FMaxComPorts write SetMaxComPorts default 4;
    property Options: TAfPortCtlOptions read FOptions write SetOptions default [pcCheckExist];
    property Align;
{$IFDEF PV_D4UP}
    property Anchors;
    property BiDiMode;
{$ENDIF}
    property Caption;
    property Color;
    property Columns;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDrag;
  end;

implementation

uses
  AfComPortCore;

const
  PS_OPEN     = 0;
  PS_CLOSE    = 1;
  PS_NOTEXIST = 2;

type
  TPortState = packed record
    ComNumber: Word;
    State: Word;
  end;

function GetPortState(PortNumber: Integer): TPortState;
var
  DeviceHandle: THandle;
  DeviceName: String;
begin
  Result.ComNumber := PortNumber;
  DeviceName := FormatDeviceName(PortNumber);
  DeviceHandle := CreateFile(PChar(DeviceName), GENERIC_READ or GENERIC_WRITE,
    0, nil, OPEN_EXISTING, 0, 0);
  if DeviceHandle = INVALID_HANDLE_VALUE then
  begin
    if GetLastError = ERROR_FILE_NOT_FOUND then
      Result.State := PS_NOTEXIST
    else
      Result.State := PS_OPEN;
  end else
  begin
    CloseHandle(DeviceHandle);
    Result.State := PS_CLOSE;
  end;
end;


{ TAfPortComboBox }

procedure TAfPortComboBox.BuildPortList;
var
  PortNumber: Integer;
  PortState: TPortState;
begin
  if csDesigning in ComponentState then Exit; 
  Items.BeginUpdate;
  try
    Items.Clear;
    for PortNumber := 1 to FMaxComPorts do
    begin
      PortState := GetPortState(PortNumber);
      if not (pcCheckExist in FOptions) or
        ((pcDisableOpen in FOptions) and (PortState.State = PS_CLOSE)) or
        (not (pcDisableOpen in FOptions) and (PortState.State in [PS_CLOSE, PS_OPEN])) then
          Items.AddObject(Format('COM %d', [PortNumber]), Pointer(PortState));
    end;
  finally
    Items.EndUpdate;
  end;
end;

procedure TAfPortComboBox.Change;
begin
  FComNumber := GetNumberFromItem(ItemIndex);
  inherited Change;
  if Assigned(FComPort) and (FComNumber <> 0) then
  try
    with FComPort do
    begin
      ComNumber := FComNumber;
      if not Active then Open;
    end;
  finally
    BuildPortList;
    UpdateItemIndex;
  end;
end;

procedure TAfPortComboBox.CMFontChanged(var Msg: TMessage);
begin
  inherited;
  ItemHeight := Abs(Font.Height) + 5;
  RecreateWnd;
end;

constructor TAfPortComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMaxComPorts := 4;
  FOptions := [pcCheckExist];
  Style := csOwnerDrawFixed;
end;

procedure TAfPortComboBox.CreateWnd;
begin
  inherited CreateWnd;
  BuildPortList;
end;

procedure TAfPortComboBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  with Canvas do
  begin
    FillRect(Rect);
    if (pcHighlightOpen in FOptions) and (State = []) and DroppedDown then
      case TPortState(Items.Objects[Index]).State of
        PS_CLOSE:
          Font.Color := clBtnText;
        PS_OPEN:
          Font.Color := clGrayText;
      end;
    TextRect(Rect, Rect.Left + 1, Rect.Top + 1, Items[Index]);
  end;
end;

function TAfPortComboBox.GetNumberFromItem(I: Integer): Word;
begin
  if I = -1 then
    Result := 0
  else
    Result := TPortState(Items.Objects[I]).ComNumber;
end;

procedure TAfPortComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FComPort) then
    ComPort := nil;
end;

procedure TAfPortComboBox.SetComNumber(const Value: Word);
begin
  if FComNumber <> Value then
  begin
    FComNumber := Value;
    UpdateItemIndex;
  end;
end;

procedure TAfPortComboBox.SetComPort(const Value: TAfComPort);
begin
  if FComPort <> Value then
  begin
    FComPort := Value;
    if Assigned(FComPort) and not (csDesigning in ComponentState) then
      ComNumber := FComPort.ComNumber;
    if Value <> nil then Value.FreeNotification(Self);
  end;
end;

procedure TAfPortComboBox.SetMaxComPorts(const Value: SmallInt);
begin
  if FMaxComPorts <> Value then
  begin
    FMaxComPorts := Value;
    BuildPortList;
  end;
end;

procedure TAfPortComboBox.SetOptions(const Value: TAfPortCtlOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    BuildPortList;
  end;  
end;

procedure TAfPortComboBox.UpdateItemIndex;
var
  I: Integer;
  Found: Boolean;
begin
  Found := False;
  for I := 0 to Items.Count - 1 do
    if GetNumberFromItem(I) = FComNumber then
    begin
      ItemIndex := I;
      Found := True;
      Break;
    end;
  if not Found then
    if Items.Count > 0 then
    begin
      ItemIndex := 0;
      FComNumber := GetNumberFromItem(0);
    end else
      FComNumber := 0;
end;

{ TAfPortRadioGroup }

type
  TDirtyCustomRadioGroup = class(TCustomGroupBox)
    ButtonsList: TList;
  end;

procedure TAfPortRadioGroup.BuildPortList(AlwaysCreate, UpdatePortState: Boolean);
const
  CaptionStr: array[Boolean] of String = ('COM %d', 'COM &%d');
var
  I: Integer;
  PortState: TPortState;

  procedure CreateItems;
var
  PortNumber: Integer;
begin
  if AlwaysCreate or (Items.Count <> FMaxComPorts) then
  begin
    if AlwaysCreate then Items.Clear;
    Items.BeginUpdate;
    try
      if not AlwaysCreate then Items.Clear;
      for PortNumber := 1 to FMaxComPorts do
      begin
        if csDesigning in ComponentState then
          PortState.State := PS_CLOSE
        else
          PortState := GetPortState(PortNumber);
        Items.AddObject(Format(CaptionStr[PortNumber < 10], [PortNumber]),
          Pointer(PortState));
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

begin
  if csReading in ComponentState then Exit;
  CreateItems;
  for I := 0 to FMaxComPorts - 1 do
  begin
    if UpdatePortState then
    begin
      PortState := GetPortState(I + 1);
      Items.Objects[I] := Pointer(PortState)
    end else
      PortState := TPortState(Items.Objects[I]);
    with TRadioButton(ButtonsList[I]) do
      case PortState.State of
        PS_CLOSE:
          begin
            Enabled := True;
            Font.Color := clBtnText;
          end;
        PS_OPEN:
          begin
            Enabled := not (pcDisableOpen in FOptions);
            if (pcDisableOpen in FOptions) or not (pcHighLightOpen in FOptions) then
              Font.Color := clBtnText
            else
              Font.Color := clGrayText;
          end;
        PS_NOTEXIST:
          begin
            Enabled := not (pcCheckExist in FOptions);
            Font.Color := clBtnText;
          end;
      end;
  end;
end;

procedure TAfPortRadioGroup.Click;
begin
  inherited Click;
  FComNumber := ItemIndex + 1;
  if Assigned(FComPort) then
  try
    with FComPort do
    begin
      ComNumber := FComNumber;
      if not Active then Open;
    end;
  finally
    BuildPortList(False, True);
  end;
end;

procedure TAfPortRadioGroup.CMFontChanged(var Msg: TMessage);
begin
  inherited;
  BuildPortList(True, False);
end;

constructor TAfPortRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMaxComPorts := 4;
  FOptions := [pcCheckExist];
  ButtonsList := TDirtyCustomRadioGroup(Self).ButtonsList;
end;

procedure TAfPortRadioGroup.CreateWnd;
begin
  inherited CreateWnd;
  if csDesigning in ComponentState then BuildPortList(False, False);
  UpdateSelectedPort;
end;

procedure TAfPortRadioGroup.Loaded;
begin
  inherited;
  BuildPortList(False, False);
  UpdateSelectedPort;
end;

procedure TAfPortRadioGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FComPort) then
    ComPort := nil;
end;

procedure TAfPortRadioGroup.SetComNumber(const Value: Word);
begin
  if FComNumber <> Value then
  begin
    FComNumber := Value;
    UpdateSelectedPort;
  end;
end;

procedure TAfPortRadioGroup.SetComPort(const Value: TAfComPort);
begin
  if FComPort <> Value then
  begin
    FComPort := Value;
    if Assigned(FComPort) and not (csDesigning in ComponentState) then
      ComNumber := FComPort.ComNumber;
  end;
end;

procedure TAfPortRadioGroup.SetMaxComPorts(const Value: SmallInt);
begin
  if FMaxComPorts <> Value then
  begin
    FMaxComPorts := Value;
    BuildPortList(False, False);
  end;
end;

procedure TAfPortRadioGroup.SetOptions(const Value: TAfPortCtlOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    BuildPortList(False, False);
  end;
end;

procedure TAfPortRadioGroup.UpdatePortList;
begin
  BuildPortList(False, True);
end;

procedure TAfPortRadioGroup.UpdateSelectedPort;
begin
  if csReading in ComponentState then Exit;
  ItemIndex := FComNumber - 1;
end;

end.
