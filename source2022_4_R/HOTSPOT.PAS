unit Hotspot;
{Soll die Region in einem CalWin-Docu erkennen und ereignisgesteuert
aktiviern, im Sinne eines Hot-Spotes}

interface

uses Controls, WinTypes, Classes, Messages, Graphics;

type
THotspot = class(TCustomControl)
  private
    FFirstPaint: Boolean;  { One-Shot wegen Designer-Bug }
    FCursor: HCursor;
    { neue Ereignisse }
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure CreateParams(var Params: TCreateParams); override;
  protected
    { verhindert "Aufblitzen" }
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure Paint; override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  published
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
end;

procedure Register;

implementation

uses WinProcs;

procedure THotspot.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure THotspot.Paint;
begin
  inherited Paint;
  if (csDesigning in ComponentState) then
  if FFirstPaint then
  begin
    FFirstPaint := False; Width := Width + 1;
  end else
  with Canvas do
  begin
    Pen.Style := psDot; Pen.Width := 1; Pen.Color := clBlack;
    Pen.Mode := pmNotXor;
    Brush.Style := bsClear;
    Rectangle(0,0,Width,Height);
    Rectangle(1,1,Width-1,Height-1);
  end;
end;

procedure THotspot.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure THotspot.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure THotspot.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or ws_ex_Transparent;
end;

constructor THotspot.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 100; Height := 100;
  FCursor := LoadCursor(HInstance, 'HandCursor');
  Cursor := crDefault;
  FFirstPaint := True;
end;

destructor THotspot.Destroy;
begin
  { Cursor bei Destroy NICHT automatisch abgeschossen }
  if Cursor = crDefault then WinProcs.SetCursor(LoadCursor(0,IDC_ARROW));
  DestroyCursor(FCursor);
  inherited Destroy;
end;

procedure THotspot.WMSetCursor(var Message: TWMSetCursor);
var FHandle: Integer;
begin
  with Message do
  begin
    if (CursorWnd = FHandle) and (HitTest = HTCLIENT) then begin
     if (csDesigning in ComponentState) or (Cursor <> crDefault) then { #AS# }
       inherited
      else begin
        WinProcs.SetCursor(FCursor);
        Result := 1;
      end;
    end
    else
      inherited;
  end;
end;

procedure Register;
begin
  RegisterComponents('CalWin', [THotspot]);
end;

end.
