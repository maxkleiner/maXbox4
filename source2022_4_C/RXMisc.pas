unit RXMisc;

interface

uses Windows, Forms, Controls;

type
  TSplitControl = class
  private
    FForm: TForm;
    FSplitControl, FSizeTarget: TControl;
    FVertical: Boolean;
    FSplit: TPoint;
    function GetSizing: Boolean;
    procedure DrawSizingLine;
  public
    constructor Create(AForm: TForm);
    procedure BeginSizing(ASplitControl, ATargetControl: TControl);
    procedure ChangeSizing(X, Y: Integer);
    procedure EndSizing;
    property Sizing: Boolean read GetSizing;
  end;

implementation

uses Graphics, SysUtils, Classes;

function CToC(C1, C2: TControl; P: TPoint): TPoint;
begin
  Result := C1.ScreenToClient(C2.ClientToScreen(P));
end;

{ TSplitControl }

constructor TSplitControl.Create(AForm: TForm);
begin
  FForm := AForm;
end;

function TSplitControl.GetSizing: Boolean;
begin
  Result := FSplitControl <> nil;
end;

procedure TSplitControl.DrawSizingLine;
var
  P: TPoint;
begin
  P := CToC(FForm, FSplitControl, FSplit);
  with FForm.Canvas do
  begin
    MoveTo(P.X, P.Y);
    if FVertical then
      LineTo(CToC(FForm, FSplitControl, Point(FSplitControl.Width, 0)).X, P.Y) else
      LineTo(P.X, CToC(FForm, FSplitControl, Point(0, FSplitControl.Height)).Y)
  end;
end;

procedure TSplitControl.BeginSizing(ASplitControl, ATargetControl: TControl);
begin
  FSplitControl := ASplitControl;
  FSizeTarget := ATargetControl;
  SetCaptureControl(FSplitControl);
  FVertical := ASplitControl.Width > ASplitControl.Height;
  if FVertical then
    FSplit := Point(0, ASplitControl.Top) else
    FSplit := Point(ASplitControl.Left, 0);
  FForm.Canvas.Handle := GetDCEx(FForm.Handle, 0, DCX_CACHE or DCX_CLIPSIBLINGS
    or DCX_LOCKWINDOWUPDATE);
  with FForm.Canvas do
  begin
    Pen.Color := clWhite;
    if FVertical then
      Pen.Width := ASplitControl.Height else
      Pen.Width := ASplitControl.Width;
    Pen.Mode := pmXOR;
  end;
  DrawSizingLine;
end;

procedure TSplitControl.ChangeSizing(X, Y: Integer);
begin
  DrawSizingLine;
  if FVertical then FSplit.Y := Y else FSplit.X := X;
  DrawSizingLine;
end;

procedure TSplitControl.EndSizing;
var
  DC: HDC;
  P: TPoint;
begin
  DrawSizingLine;
  P := CToC(FSizeTarget, FSplitControl, FSplit);
  SetCaptureControl(nil);
  FSplitControl := nil;
  with FForm do
  begin
    DC := Canvas.Handle;
    Canvas.Handle := 0;
    ReleaseDC(Handle, DC);
  end;
  if FVertical then
    FSizeTarget.Height := P.Y else
    FSizeTarget.Width  := P.X;
end;

end.
