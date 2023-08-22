
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 1995-2003 Borland Software Corporation }
{                                                       }
{*******************************************************}

unit CollPanl;

interface

uses
  SysUtils, Classes, Messages, Controls, StdCtrls, ExtCtrls, Graphics;

type
  THeaderPanel = class(TComponent)
  private
    FPanel: TPanel;
    function GetCaption: TCaption;
    procedure SetCaption(const Value: TCaption);
    function GetHeight: Integer;
    procedure SetHeight(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption: TCaption read GetCaption write SetCaption;
    property Height: Integer read GetHeight write SetHeight;
  end;

  TCollapsePanel = class(TCustomPanel)
  private
    { Private declarations }
    FHeader: THeaderPanel;
    FCollapseButton: TLabel;
    FExpandedHeight: Integer;
    FStep: Integer;
    FExpanded: Boolean;
    FExpanding: Boolean;
    FActiveHeaderColor: TColor;
    FInactiveHeaderColor: TColor;
    function GetMinHeight: Integer;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
    procedure SetStep(const Value: Integer);
    function GetActiveHeaderColor: TColor;
    function GetInactiveHeaderColor: TColor;
    procedure SetActiveHeaderColor(const Value: TColor);
    procedure SetInactiveHeaderColor(const Value: TColor);
  protected
    { Protected declarations }
    procedure CollapseButtonClick(Sender: TObject);
    procedure PanelClick(Sender: TObject);
    procedure SetHeaderPanel;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    property Expanded: Boolean read FExpanded;
  published
    function GetHeaderCaption: string;
    function GetHeaderHeight: Integer;
    procedure SetHeaderCaption(const Value: &string);
    procedure SetHeaderHeight(const Value: Integer);
  published
    { Published declarations }
    property ActiveHeaderColor: TColor read GetActiveHeaderColor write SetActiveHeaderColor;
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property HeaderCaption: string read GetHeaderCaption write SetHeaderCaption;
    property HeaderHeight: Integer read GetHeaderHeight write SetHeaderHeight;
    property InactiveHeaderColor: TColor read GetInactiveHeaderColor write SetInactiveHeaderColor;
    property Locked;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
    property ShowHint;
    property Step: Integer read FStep write SetStep;
    property TabOrder;
    property TabStop;
    property VerticalAlignment;
    property Visible;
  end;

implementation

uses
  Dialogs,
  Windows;

{ TCollapsePanel }

constructor TCollapsePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  SetHeaderPanel;
  FCollapseButton := TLabel.Create(Self);

  Width := 150;
  Height := 270;
  Color := clWhite;
  BevelInner := bvRaised;
  BevelOuter := bvLowered;
  FExpandedHeight := Height;
  FStep := 8;
  FExpanded := True;
  FExpanding := False;
  FActiveHeaderColor := clBlue;
  FInactiveHeaderColor := clSkyBlue;
  ParentBackground := False;
  TabStop := True;

  // Set CollapseButton default properties.
  with FCollapseButton do
  begin
    Parent := FHeader.FPanel;
    Align:= alRight;
    Alignment := taRightJustify;
    Caption := ' << ';
    Font.Color:= clWhite;
    Cursor := crHandPoint;
    OnClick := CollapseButtonClick;
  end;
  
  FHeader.FPanel.OnDblClick := CollapseButtonClick;

  if (TabOrder <> 0) and not (csDesigning in ComponentState) then
    FHeader.FPanel.Color:= FInactiveHeaderColor
  else
    FHeader.FPanel.Color:= FActiveHeaderColor;
end;

procedure TCollapsePanel.CollapseButtonClick(Sender: TObject);
begin
  PanelClick(Self);
  FExpanded := not FExpanded;

  if FCollapseButton.Caption = ' << ' then
  begin
    // Expanded
    FCollapseButton.Caption:= ' >> ';
    FHeader.FPanel.Color:= clMedGray;

    FExpanding := True;
    repeat
      if Height - FStep <= FHeader.FPanel.Height then
      begin
        Height:= FHeader.FPanel.Height;
        Break;
      end
      else
        Height:= Height - FStep;
      Refresh;
    until Height <= FHeader.FPanel.Height;
    Height := FHeader.FPanel.Height;

    FExpanding := False;
  end
  else
  begin
    // Collapsed
    FCollapseButton.Caption:= ' << ';
    FHeader.FPanel.Color:= FActiveHeaderColor;

    FExpanding := True;
    repeat
      if Height + FStep >= FExpandedHeight  then
      begin
        Height:= FExpandedHeight;
        Break;
      end
      else
        Height:= Height + FStep;
      Refresh;
    until Height = FExpandedHeight;
    FExpanding := False;
  end;
  if Align = alClient then
    NotifyControls(WM_SIZE);
end;

function TCollapsePanel.GetActiveHeaderColor: TColor;
begin
  Result:= FActiveHeaderColor;
end;

procedure TCollapsePanel.SetActiveHeaderColor(const Value: TColor);
begin
  if FActiveHeaderColor <> Value then
  begin
    FActiveHeaderColor := Value;
    if Focused or (csDesigning in ComponentState) then
    begin
      FHeader.FPanel.Color := FActiveHeaderColor;
      FHeader.FPanel.Invalidate;
    end;
  end;
end;

function TCollapsePanel.GetInactiveHeaderColor: TColor;
begin
  Result:= FInactiveHeaderColor;
end;

procedure TCollapsePanel.SetInactiveHeaderColor(const Value: TColor);
begin
  if FInactiveHeaderColor <> Value then
  begin
    FInactiveHeaderColor := Value;
    if not Focused and not (csDesigning in ComponentState) then
    begin
      FHeader.FPanel.Color := FInactiveHeaderColor;
      FHeader.FPanel.Invalidate;
    end;
  end;
end;

procedure TCollapsePanel.PanelClick(Sender: TObject);
begin
  if FExpanded then
    FHeader.FPanel.Color:= FActiveHeaderColor;
  if not (csDesigning in ComponentState) and CanFocus then
    SetFocus;
end;

function TCollapsePanel.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  I := SysMetrics.tmHeight;
  if I > Metrics.tmHeight then I := Metrics.tmHeight;
  Result := Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4;

  if Result < FHeader.FPanel.Height  then
    Result := FHeader.FPanel.Height;
end;

procedure TCollapsePanel.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
begin
  MinHeight := GetMinHeight;

  if (csDesigning in ComponentState) or (not FExpanding) then
    FExpandedHeight := Height;

  if FExpanded then
  begin
    inherited;
    if Height < MinHeight then
      Height := MinHeight;
  end
  else
  begin
    Height := MinHeight;
  end;
end;

procedure TCollapsePanel.CMEnter(var Message: TCMGotFocus);
begin
  if FExpanded then
    FHeader.FPanel.Color:= FActiveHeaderColor;
  inherited;
end;

procedure TCollapsePanel.CMExit(var Message: TCMExit);
begin
  if FExpanded then
    FHeader.FPanel.Color:= FInactiveHeaderColor;;
  inherited;
end;

procedure TCollapsePanel.SetStep(const Value: Integer);
begin
  if (Value <> FStep) then
    if (Value > 0) then
      FStep := Value
    else
      FStep:= 1;
end;

procedure TCollapsePanel.SetHeaderPanel;
begin
  FHeader := THeaderPanel.Create(Self);
  FHeader.SetSubComponent(True);
  with FHeader.FPanel do
  begin
    Parent := Self;
    Color:= FActiveHeaderColor;
    OnClick:= PanelClick;
  end;
end;

function TCollapsePanel.GetHeaderCaption: string;
begin
  Result := FHeader.Caption;
end;

function TCollapsePanel.GetHeaderHeight: Integer;
begin
  Result := FHeader.Height;
end;

procedure TCollapsePanel.SetHeaderCaption(const Value: string);
begin
  FHeader.Caption := Value;
end;

procedure TCollapsePanel.SetHeaderHeight(const Value: Integer);
begin
  FHeader.Height := Value;
end;

{ THeaderPanel }

constructor THeaderPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPanel:= TPanel.Create(AOwner);
  with FPanel do
  begin
    Height := 17;
    Align := alTop;
    Alignment := taLeftJustify;
    Font.Color := clWhite;
    BevelInner := bvNone;
    BevelOuter := bvLowered;
    Caption := ' Header';
    ParentBackground := False;
  end;
end;

function THeaderPanel.GetCaption: TCaption;
begin
  Result := Copy(FPanel.Caption, 2, Length(FPanel.Caption)-1);
end;

procedure THeaderPanel.SetCaption(const Value: TCaption);
var
  Temp : string;
begin
  Temp := ' ' + Value;
  if Temp <> FPanel.Caption then
    FPanel.Caption := Temp;
end;


function THeaderPanel.GetHeight: Integer;
begin
  Result := FPanel.Height;
end;

procedure THeaderPanel.SetHeight(const Value: Integer);
begin
  if Value <> FPanel.Height then
  begin
    FPanel.Height := Value;
    FPanel.Invalidate;
  end;
end;

end.
