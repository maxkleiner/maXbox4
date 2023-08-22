unit AnalogMeter;
{ Written 1999 by Hannes Breuer (hannes.breuer@talknet.de)
               inspired by Andrey Abakumov (aga@novoch.ru)

  Version 2.0 : 1.10.1999
          First release version, never mind the private version's history...
  Version 2.01 : 6.10.1999
          Split DrawFace into DrawOuterFace and DrawInnerFace for speed.
          Cleaned up uses-clause

  Licensing: Use however you want.
  Please tell me where you use it (location and use of program).
  If you fix bugs or add nifty features, please let me know.
  If you earn money with it, please mention me.

  I WILL NOT ASSUME ANY RESPONSIBILITY WHATSOEVER FOR ANY DAMAGES RESULTING
  FROM THE USE/MISUSE OF THIS UNIT. Use at your own risk.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, ExtCtrls;

type
  TAnalogMeter = class(TPaintBox)
  private
    //purely internal stuff:
    fBitmap : TBitMap;
    fZeroAngle     : Single;  //depends on AngularRange, counted Clockwise from straight down, in Degrees
    fCentrePoint   : TPoint;  //gets shifted according to size and Angular range
    fOuterHalfAxes,
    fInnerHalfAxes : TPoint;  //dimensions of ellipses
    fFrameWidth : LongInt;    //adjusted according to size
    fTxtHeight     : LongInt; //gets set in Paint according to Font
    fOldValue : LongInt;      //needed to XOR over old display
    //events:
    FonResize : TNotifyEvent;
    FonChange : TNotifyEvent;
    FonRiseAboveHigh : TNotifyEvent;
    FonFallBelowHigh : TNotifyEvent;
    FonRiseAboveLow : TNotifyEvent;
    FonFallBelowLow : TNotifyEvent;
    fEnableZoneEvents : Boolean;   //allow switching them off wholesale
    //variables for properties:
    fCaption : String;
    fMin, fMax, fValue : LongInt;  //just like TSpinEdit
    fAngularRange : LongInt;       //portion of circle to be used for display, 10..360 (degrees)
    fTickCount : LongInt;          //how many should be shown (including first & last)
    fLowZone,
    fHighZone : Single;            //real values, Set/Get work with percentage
    fShowFrame,
    fShowTicks,
    fShowValue : Boolean;
    fTickColor,
    fHighZoneColor,
    fLowZoneColor,
    fOKZoneColor : TColor;
    Procedure SetCaption(s : String);
    Procedure SetMin(m : LongInt);
    Procedure SetMax(m : LongInt);
    Procedure SetValue(v : LongInt);
    Procedure SetAngularRange(r : LongInt);
    Procedure SetTickCount(t : LongInt);
    Procedure SetLowZone(percent : Byte);
    Function GetLowZone : Byte;
    Procedure SetHighZone(percent : Byte);
    Function GetHighZone : Byte;
    Procedure SetShowValue(b : Boolean);
    Procedure SetHighZoneColor(c : TColor);
    Procedure SetLowZoneColor(c : TColor);
    Procedure SetOKZoneColor(c : TColor);
    Procedure SetTickColor(c : TColor);
    Procedure SetShowTicks(b : Boolean);
    Procedure SetShowFrame(b : Boolean);
    Procedure SetFont(F : TFont);
    Function GetFont : TFont;
    //internal stuff:
    Procedure WMSize(var Message : TWMSize); message 15;//WM_SIZE does not arrive here...
//    Procedure WMSize(var Message : TWMSize); message WM_SIZE;
    //drawing routines:
    Function AngleOf(v : Single) : Single; //calcs angle corresponding to value v
    Procedure OptimizeSizes; //according to dimensions and angular range
    Procedure ClearCanvas;
    Procedure DrawFrame;
    Procedure DrawRegions;
    Procedure ClearInnerFace;
    Procedure DrawTicks;
    Procedure DrawCaption;
    Procedure DrawPointer;
    Procedure DrawValue;
    Procedure DeleteOldValue;
    Procedure DrawOuterFace; //onto Bitmap in background
    Procedure DrawInnerFace; //onto Bitmap in background
  protected
    Procedure Paint; override; //BitBlt Background-Bitmap onto canvas
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption : String read fCaption write SetCaption;
    property Min : LongInt read fMin write SetMin default 0;
    property Max : LongInt read fMax write SetMax default 100;
    property Value : LongInt read fValue write SetValue default 0;
    property AngularRange : LongInt read fAngularRange write SetAngularRange default 270;
    property TickCount : LongInt read fTickCount write SetTickCount default 7;
    property LowZone : Byte read GetLowZone write SetLowZone default 10;
    property HighZone : Byte read GetHighZone write SetHighZone default 90;
    property ShowValue : Boolean read fShowValue write SetShowValue default True;
    property HighZoneColor : TColor read fHighZoneColor write SetHighZoneColor default clRed;
    property LowZoneColor  : TColor read fLowZoneColor write SetLowZoneColor default clYellow;
    property OKZoneColor   : TColor read fOKZoneColor write SetOKZoneColor default cl3DLight;
    property TickColor : TColor read fTickColor write SetTickColor default clBlack;
    property ShowTicks : Boolean read fShowTicks write SetShowTicks default True;
    property ShowFrame : Boolean read fShowFrame write SetShowFrame default True;
    //own events:
    property onResize : TNotifyEvent read fOnResize write FonResize;
    property onChange : TNotifyEvent read FonChange write FonChange;
    property EnableZoneEvents : Boolean read fEnableZoneEvents write fEnableZoneEvents default True;
    property onRiseAboveHigh : TNotifyEvent
        read FonRiseAboveHigh
       write FonRiseAboveHigh;
    property onFallBelowHigh : TNotifyEvent
        read FonFallBelowHigh
       write FonFallBelowHigh;
    property onRiseAboveLow : TNotifyEvent
        read FonRiseAboveLow
       write FonRiseAboveLow;
    property onFallBelowLow : TNotifyEvent
        read FonFallBelowLow
       write FonFallBelowLow;
    //publish inherited stuff:
    property Align;
    property Color;
    property Font : TFont read GetFont write SetFont;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
{    property OnEnter;    //##NOPE, defined in TControl, not visible to me
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;    }
  end;

procedure Register;

implementation

{------------------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponents('Samples', [TAnalogMeter]);
end;

{-------------------some necessary utils---------------------------------------}
{------------------------------------------------------------------------------}
Function Radius(Theta : Single; HalfAxes : TPoint) : Single;
         //calculates length of 'radius' in ellipse defined by the half-axes at
         //angle Theta (0 is straight down, clockwise, in degrees)
Var C, S : Single;  //Cos / Sin
    w, h : LongInt; //half-axes
Begin
  C := Cos(Theta*Pi/180);
  S := Sin(Theta*Pi/180);
  w := HalfAxes.X;
  h := HalfAxes.Y;
  If (w <= 0) or (h <= 0) then begin
    Result := 0;
    Exit;
  end;
  Result := w*h/Sqrt(h*h*S*S + w*w*C*C);
End;

{------------------------------------------------------------------------------}
Function XinEllipse(Theta : Single; HalfAxes : TPoint) : LongInt;
         //calculates X-posn of point on ellipse at angle Theta
Var R : Single;
Begin
  R := Radius(Theta,Halfaxes);
  Result := Round(-R*Sin(Theta*Pi/180)); //theta counted from straight down, clockwise
End;

{------------------------------------------------------------------------------}
Function YinEllipse(Theta : Single; HalfAxes : TPoint) : LongInt;
         //calculates Y-posn of point on ellipse at angle Theta
Var R : Single;
Begin
  R := Radius(Theta,Halfaxes);
  Result := Round(R*Cos(Theta*Pi/180)); //theta counted from straight down, clockwise
End;

{------------------------------------------------------------------------------}
Function OptimalHalfHeight(AvailableHeight : LongInt; Theta : Single; Width : LongInt) : LongInt;
         //calculates optimal ellipse half-height if only part of the ellipse needs to fit
         //into the AvailableHeight. Theta is the ZeroAngle
Var UsedHeight : Single;
    H : LongInt; //half-height, found by trial as the equation is not
                 // analytically solvable       // by me ;)
    C, S, T : Single; //Cos, Sin and a temp. variable for speed
Begin
  If Theta >= 90 then begin //centre MUST be shown
    Result := AvailableHeight;
    Exit;
  end;
  S := Sin(Theta*Pi/180);
  S := Sqr(S);  //only the sqr is needed later on
  C := Cos(Theta*Pi/180);
  C := Width*C/2; //only the product is needed later on
  T := Sqr(C);
  //OK, start at H = 1/2 of available and Inc(H) it until it gets too big:
  H := AvailableHeight div 2;
  UsedHeight := H + H*C / Sqrt(Sqr(H)*S + T); //basically H +Radius*Cos(Theta), just sped up
  While UsedHeight < AvailableHeight do begin
    Inc(H);
    UsedHeight := H + H*C / Sqrt(Sqr(H)*S + T);
  end;
  Dec(H); //remember that it was Inc'ed once too often
  Result := H;
End;

{-------------------------TAnalogMeter-----------------------------------------}
{------------------------------------------------------------------------------}
Constructor TAnalogMeter.Create(AOwner: TComponent);
Begin
  inherited Create(AOwner);
  fBitmap := TBitmap.Create;
  //defaults:
  Width  := 121;
  Height := 117;
  fCaption := 'mV';
  fMin   := 0;
  fMax   := 100;
  fValue := 0;
  fOldValue := fValue;
  fAngularRange  := 270;
  fTickCount     := 11;
  fLowZone   := 10;
  fHighZone  := 90;
  fShowValue := True;
  //internal stuff:
  fZeroAngle := 45;
  fTxtHeight := 8;
  fHighZoneColor := clRed;
  fLowZoneColor  := clYellow;
  fOKZoneColor   := cl3DLight;
  fTickColor     := clBlack;
  fShowTicks     := True;
  fShowFrame     := True;
  fEnableZoneEvents := True;
End;

{------------------------------------------------------------------------------}
Destructor TAnalogMeter.Destroy;
Begin
  fBitmap.Free;
  inherited Destroy;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.WMSize(var Message : TWMSize);
Begin
  If Height < 37 then Height := 37; //anything else is nonsense
  If Width  < 52 then Width  := 52;
  If Assigned(FonResize) then FonResize(Self);
  OptimizeSizes;
  fBitmap.Width  := Width;
  fBitmap.Height := Height;
  DrawOuterFace;
  DrawInnerFace;
  inherited;
End;

{------------------------------------------------------------------------------}
Function TAnalogMeter.GetFont : TFont;
Begin
  Result := fBitmap.Canvas.Font;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetFont(f : TFont);
Begin
  If fBitmap.Canvas.Font = f then Exit;
  fBitmap.Canvas.Font := f;
  fTxtHeight := fBitmap.Canvas.TextHeight('S');
  If fShowValue or (Trim(fCaption) <> '') then begin
    DrawOuterFace;
    DrawInnerFace;
    Paint;
  end;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetCaption(s : String);
Begin
  s := Trim(s);
  If fCaption = s then Exit;
  fCaption := s;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetMin(m : LongInt);
Var OldLow, OldHigh : Longint;
Begin
  If m > fMax then m := fMax;    //force consistency
  If fMin = m then Exit;         //no action needed
  OldLow := GetLowZone;          //in %!
  OldHigh := GetHighZone;
  fMin := m;
  If fValue < m then Value := m; //force consistency
  SetLowZone(OldLow);            //converts internally
  SetHighZone(OldHigh);
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetMax(m : LongInt);
Var OldLow, OldHigh : Longint;
Begin
  If m < fMin then m := fMin;    //force consistency
  If fMax = m then Exit;         //no action needed
  OldLow := GetLowZone;          //in %!
  OldHigh := GetHighZone;
  fMax := m;
  If fValue > m then Value := m; //force consistency
  SetLowZone(OldLow);            //converts internally
  SetHighZone(OldHigh);
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetValue(v : LongInt);
Var TriggerHi, TriggerLo : Boolean;
Begin
  If v < fMin then v := fMin;
  If v > fMax then v := fMax;
  If v = fValue then Exit;
  fOldValue := fValue;
  fValue := v;
  If Assigned(FonChange) then FonChange(Self);
  //redraw:
  DrawInnerFace;
  Paint;
  //call events if necessary:
  If not fEnableZoneEvents then Exit;
  TriggerHi := Assigned(FonRiseAboveHigh) and (fOldValue < fHighZone) and (fValue >= fHighZone);
  TriggerLo := Assigned(FonFallBelowLow) and (fOldValue >= fLowZone) and (fValue < fLowZone);
  If TriggerLo then FonFallBelowLow(Self);
  If TriggerHi then FonRiseAboveHigh(Self);
  If not (TriggerHi or TriggerLo) then begin//only trigger one the two events if we move through 2 zones:
    If Assigned(FonFallBelowHigh) and (fOldValue >= fHighZone) and (fValue < fHighZone)
      then FonFallBelowHigh(Self);
    If Assigned(FonRiseAboveLow) and (fOldValue < fLowZone) and (fValue >= fLowZone)
      then FonRiseAboveLow(Self);
  end;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetAngularRange(r : LongInt);
Begin
  If r < 10 then r := 10;         //hard limits
  If r > 360 then r := 360;
  If r = fAngularRange then Exit; //no action needed
  fAngularRange := r;
  fZeroAngle := (360-AngularRange)/2;
  OptimizeSizes;
  //redraw:
  DrawOuterFace;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetTickCount(t : LongInt);
Begin
  If t < 0 then t := 0;                     //hard limits
  If t > (fMax-fMin) then t := Fmax - fMin;
  If t = fTickCount then Exit;              //no action needed
  fTickCount := t;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetLowZone(percent : Byte);
Var fOldLow : Single;
Begin
  If percent < 0   then percent := 0;   //hard limits
  If percent > 100 then percent := 100;
  If percent = LowZone then Exit; //no action needed
  If percent > HighZone then HighZone := percent; //ensure integrity
  fOldLow := fLowZone;
  fLowZone := Min + (Max-Min)*percent/100;
  DrawOuterFace;
  DrawInnerFace;
  Paint;
  //call events if necessary:
  If not fEnableZoneEvents then Exit;
  If Assigned(FonFallBelowLow) and (fValue >= fOldLow) and (fValue < fLowZone)
    then FonFallBelowLow(Self);
  If Assigned(FonRiseAboveLow) and (fValue < fOldLow) and (fValue >= fLowZone)
    then FonRiseAboveLow(Self);
End;

{------------------------------------------------------------------------------}
Function TAnalogMeter.GetLowZone : Byte;
Begin
  If Max = Min
    then Result := 0
    else Result := Round(100*(fLowZone - Min)/(Max - Min));
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetHighZone(percent : Byte);
Var fOldHigh : Single;
Begin
  If percent < 0   then percent := 0;   //hard limits
  If percent > 100 then percent := 100;
  If percent = HighZone then Exit; //no action needed
  If percent < LowZone then LowZone := percent; //ensure integrity
  fOldHigh := fHighZone;
  fHighZone := Min + (Max-Min)*percent/100;
  DrawOuterFace;
  DrawInnerFace;
  Paint;
  //call events if necessary:
  If not fEnableZoneEvents then Exit;
  If Assigned(FonFallBelowHigh) and (fValue >= fOldHigh) and (fValue < fHighZone)
    then FonFallBelowHigh(Self);
  If Assigned(FonRiseAboveHigh) and (fValue < fOldHigh) and (fValue >= fHighZone)
    then FonRiseAboveHigh(Self);
End;

{------------------------------------------------------------------------------}
Function TAnalogMeter.GetHighZone : Byte;
Begin
  If Max = Min
    then Result := 0
    else Result := Round(100*(fHighZone - Min)/(Max - Min));
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetShowValue(b : Boolean);
Begin
  If b = fShowValue then Exit;
  fShowValue := b;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetHighZoneColor(c : TColor);
Begin
  If fHighZoneColor = c then Exit;
  fHighZoneColor := c;
  DrawOuterFace;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetLowZoneColor(c : TColor);
Begin
  If fLowZoneColor = c then Exit;
  fLowZoneColor := c;
  DrawOuterFace;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetOKZoneColor(c : TColor);
Begin
  If fOKZoneColor = c then Exit;
  fOKZoneColor := c;
  DrawOuterFace;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetTickColor(c : TColor);
Begin
  If fTickColor = c then Exit;
  fTickColor := c;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetShowTicks(b : Boolean);
Begin
  If fShowTicks = b then Exit;
  fShowTicks := b;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetShowFrame(b : Boolean);
Begin
  If fShowFrame = b then Exit;
  fShowFrame := b;
  DrawOuterFace;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
{--------------- drawing routines: all on fBitmap in background ---------------}
{------------------------------------------------------------------------------}
Function TAnalogMeter.AngleOf(v : Single) : Single;
Begin
  Result := fZeroAngle + fAngularRange*(v - fMin)/(fMax-fMin);
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.OptimizeSizes;
var TH : LongInt; //space for text at the bottom
Begin
  TH := fTxtHeight + 2;
  fFrameWidth := (Width + Height) div 40;
  fOuterHalfAxes.Y := OptimalHalfHeight(Height - 2*fFrameWidth - TH, fZeroAngle, Width - 2*fFrameWidth);
  fCentrePoint.Y := fFrameWidth + fOuterHalfAxes.Y;
  fCentrePoint.X := Width Div 2;
  fOuterHalfAxes.X := fCentrePoint.X-fFrameWidth;
  fInnerHalfAxes := Point(fOuterHalfAxes.X - ((Width+Height)div 25),
                          fOuterHalfAxes.Y - ((Width+Height)div 25));
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.ClearCanvas;
Begin
  with fBitmap.Canvas do begin
    Brush.Style := bsClear;
    Brush.Color := Self.Color;
    FillRect(ClientRect);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawFrame;
Begin
  with fBitmap.Canvas do begin
    Pen.Color := clBtnShadow;
    Pen.Width := 1;
    MoveTo(0,Height);
    LineTo(0,0);
    LineTo(Width-1,0);
    Pen.Color := clBtnHighLight;
    LineTo(Width-1,Height-1);
    LineTo(0,Height-1);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawRegions;
Var Xzero, Yzero,
    Xlow, Ylow,
    XHi, YHi : LongInt;
    LowAngle, HiAngle : Single;
Begin
  //3 arcs for the 3 zones:
  LowAngle := AngleOf(fLowZone);
  HiAngle  := AngleOf(fHighZone);
  Xzero := XInEllipse(fZeroAngle,fOuterHalfAxes);
  Yzero := YInEllipse(fZeroAngle,fOuterHalfAxes);
  XLow  := XInEllipse(LowAngle,fOuterHalfAxes);
  YLow  := YInEllipse(LowAngle,fOuterHalfAxes);
  XHi   := XInEllipse(HiAngle,fOuterHalfAxes);
  YHi   := YInEllipse(HiAngle,fOuterHalfAxes);
   //fill zones with colours:
  with fBitmap.Canvas do begin
    Pen.Width := 2;
    If Color = clBtnShadow then Pen.Color := cl3DLight
                           else Pen.Color := clBtnShadow;
    If fLowZone > fMin then begin
      Brush.Color := fLowZoneColor;
      Pie(fCentrePoint.X-fOuterHalfAxes.X, fCentrePoint.Y-fOuterHalfAxes.Y,
          fCentrePoint.X+fOuterHalfAxes.X, fCentrePoint.Y+fOuterHalfAxes.Y,
          fCentrePoint.X + XLow, fCentrePoint.Y + YLow,
          fCentrePoint.X + Xzero, fCentrePoint.Y + Yzero);
    end;
    If (fHighZone > fLowZone) then begin
      Brush.Color := fOKZoneColor;
      Pie(fCentrePoint.X-fOuterHalfAxes.X, fCentrePoint.Y-fOuterHalfAxes.Y,
          fCentrePoint.X+fOuterHalfAxes.X, fCentrePoint.Y+fOuterHalfAxes.Y,
          fCentrePoint.X + XHi, fCentrePoint.Y + YHi,
          fCentrePoint.X + XLow, fCentrePoint.Y + YLow);
    end;
    If (fHighZone < fMax) then begin
      Brush.Color := fHighZoneColor;
      Pie(fCentrePoint.X-fOuterHalfAxes.X, fCentrePoint.Y-fOuterHalfAxes.Y,
          fCentrePoint.X+fOuterHalfAxes.X, fCentrePoint.Y+fOuterHalfAxes.Y,
          fCentrePoint.X - Xzero, fCentrePoint.Y + Yzero,
          fCentrePoint.X + XHi, fCentrePoint.Y + YHi);
    end;
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.ClearInnerFace;
Var Xzero, Yzero : LongInt;
Begin
  Xzero := XInEllipse(fZeroAngle,fOuterHalfAxes);
  Yzero := YInEllipse(fZeroAngle,fOuterHalfAxes);
  with fBitmap.Canvas do begin
    Pen.Width := 2;
    If Color = clBtnShadow then Pen.Color := cl3DLight
                           else Pen.Color := clBtnShadow;
    Arc(fCentrePoint.X-fInnerHalfAxes.X, fCentrePoint.Y-fInnerHalfAxes.Y,
        fCentrePoint.X+fInnerHalfAxes.X, fCentrePoint.Y+fInnerHalfAxes.Y,
        fCentrePoint.X - Xzero, fCentrePoint.Y + Yzero,
        fCentrePoint.X + Xzero, fCentrePoint.Y + Yzero);
    //overwrite colours:
    Pen.Color := Color;  //don't want edges of pie
    Brush.Color := Color;
    Ellipse(fCentrePoint.X-fInnerHalfAxes.X+2, fCentrePoint.Y-fInnerHalfAxes.Y+2,
        fCentrePoint.X+fInnerHalfAxes.X-2, fCentrePoint.Y+fInnerHalfAxes.Y-2);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawTicks;
var i : LongInt;
    SmallEllipse : TPoint;
    Angle : Single;
Begin
  SmallEllipse.X := fInnerHalfAxes.X-((Width+Height) div 35);
  SmallEllipse.Y := fInnerHalfAxes.Y-((Width+Height) div 35);
  with fBitmap.Canvas do begin
    Pen.Color := fTickColor;
    Pen.Width := 1;
    For i := 1 to fTickCount do begin
      Angle := AngleOf(Min + (Max-Min)*(i-1)/(fTickCount-1));
      MoveTo(fCentrePoint.X + XInEllipse(Angle,fInnerHalfAxes),
             fCentrePoint.Y + YInEllipse(Angle,fInnerHalfAxes));
      LineTo(fCentrePoint.X + XInEllipse(Angle,SmallEllipse),
             fCentrePoint.Y + YInEllipse(Angle,SmallEllipse));
    end;
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawCaption;
var TW: LongInt; //textwidth
    H, H1, H2 : LongInt;
Begin
  H1 := fCentrePoint.Y - ((Width + Height) div 40); //top of knob
  H2 := fCentrePoint.Y - fInnerHalfAxes.Y - 1;      //bottom of scale
  H  := (H1 + H2) div 2;
  with fBitmap.Canvas do begin
    Brush.Color := Color; //background
    TW := TextWidth(fCaption) div 2;
    TextOut(fCentrePoint.X - TW, H, fCaption);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawPointer;
var angle : Single;
    X,Y : LongInt;
    SmallEllipse : TPoint;
    Radius : LongInt;
Begin
  with fBitmap.Canvas do begin
    //hand:
    SmallEllipse.X := fInnerHalfAxes.X-3;
    SmallEllipse.Y := fInnerHalfAxes.Y-3;
    angle := AngleOf(fValue);
    X := XInEllipse(Angle,SmallEllipse);
    Y := YInEllipse(Angle,SmallEllipse);
    Pen.Width := 2;
    Pen.Color := fTickColor;
    MoveTo(fCentrePoint.X, fCentrePoint.Y);
    LineTo(fCentrePoint.X + X, fCentrePoint.Y + Y);
    //knob:
    Radius := (Width + Height) div 40;
    //shadow:
    Pen.Width := 3;
    Pen.Color := clBtnShadow;
    Ellipse(fCentrePoint.X - Radius+1, fCentrePoint.Y - Radius,
            fCentrePoint.X + Radius+1, fCentrePoint.Y + Radius);
    //knob itself, in colour of current zone:
    Pen.Width := 1;
    If (fLowZone > fMin) and (fValue <= fLowZone)
      then Brush.Color := fLowZoneColor
      else If (fHighZone < fMax) and (fValue >= fHighZone)
        then Brush.Color := fHighzoneColor
        else Brush.Color := fOKzoneColor;
    Pen.Color := Brush.Color;
    Ellipse(fCentrePoint.X - Radius, fCentrePoint.Y - Radius,
            fCentrePoint.X + Radius, fCentrePoint.Y + Radius);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawValue;
var s : String;
Begin
  s := IntToStr(Value);
  with fBitmap.Canvas do begin
    Brush.Style := bsClear;
    TextOut(fCentrePoint.X - (TextWidth(s) div 2),
            Height- fFrameWidth -fTxtHeight -1, s);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DeleteOldValue;
var s : String;
    c : TColor;
Begin
  s := IntToStr(fOldValue);
  with fBitmap.Canvas do begin
    Brush.Style := bsClear;
    c := Font.Color;
    Font.Color  := Color;
    TextOut(fCentrePoint.X - (TextWidth(s) div 2),
            Height- fFrameWidth -fTxtHeight -1, s);
    Font.Color := c; //reset
  end;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawOuterFace;
Begin
  ClearCanvas;
  DrawRegions;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawInnerFace;
Begin
  ClearInnerFace;
  If fShowTicks and (TickCount > 1) then DrawTicks;
  If fCaption <> '' then DrawCaption;
  If fShowValue then DeleteOldValue;
  DrawPointer;
  If fShowValue then DrawValue;
  If fShowFrame then DrawFrame;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.Paint;
Begin
  BitBlt(Canvas.Handle, 0, 0, Width, Height,
         fBitmap.Canvas.Handle, 0, 0, SRCCOPY);
End;

end.
