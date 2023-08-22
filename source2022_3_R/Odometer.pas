unit Odometer;
{
Component: TOdometer
Version: 1.01
Author: Craig Manley.
Email: c.manley@chello.nl
Website: http://www.skybound.nl
Last updated: 6 March 2000

Notice:
You may use this component free of charge in any project as long as this
source code is left intact. Please report bugs fixes or improvements to me
by email. You may modify the bitmap of digits if you want and I'ld like it
if you send me a copy if you do so.

Description:
This component simulates a decimal, hexadecimal, or binary odometer.
It can optionally use no animation, threaded animation, or non-threaded
animation to roll the digits over when it's value is increased or decreased.
When using threaded animation (by setting Animated to True and Threaded
to True).
}


interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, extctrls;

type
  TBaseType = (btBinary, btDecimal, btHexadecimal);
  TAnimationType = (atNone, atSynchronous, atAsynchronous);

  TOdometer = class(TGraphicControl)
  private
    FAnimationType: TAnimationType;
    FBaseType: TBaseType;
    FBitmap: TBitmap;
    FDigitCount: byte;
    FDigitHeight: byte;
    FDigits: TBitmap; // A column of digit images [0..F,blank].
    FDisplay: TBitmap;
    FIncTopToBottom: boolean;
    FLimit: Cardinal;
    FValue: Cardinal;
    // Timer fields - must be initialized before timer starts
    FTimer: TTimer;
    FOldValue,
    FNewValue: string;
    FFrameNo: integer;
    FIncreasing: boolean;
    procedure Draw;
    procedure DrawAnimated(const AOldValue, ANewValue: string; AIncreasing: boolean);
    procedure StartTimerAni(const AOldValue, ANewValue: string; AIncreasing: boolean);
    procedure TimerEvent(Sender: TObject);
    procedure UpdateLimit;
  protected
    procedure SetBaseType(AValue: TBaseType);
    procedure SetDigitCount(AValue: byte);
    function GetFrameInterval: byte;
    procedure SetFrameInterval(AValue: byte);
    procedure SetValue(AValue: Cardinal);
    function GetHeight: Integer;
    function GetWidth: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Increase;
    procedure Decrease;
  published
    //property Busy: boolean read FBusy;
    property AnimationType: TAnimationType read FAnimationType write FAnimationType;
    property Height: Integer read GetHeight;
    property Width: Integer read GetWidth;
    property FrameInterval: byte read GetFrameInterval write SetFrameInterval;
    property BaseType: TBaseType read FBaseType write SetBaseType;
    property DigitCount: byte read FDigitCount write SetDigitCount;
    property Limit: Cardinal read FLimit;
    property IncTopToBottom: boolean read FIncTopToBottom write FIncTopToBottom;
    property ShowHint;
    property Value: Cardinal read FValue write SetValue;
  end;

{$R *.RES}

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Freeware', [TOdometer]);
end;

{============================= General functions ==============================}
function Numb2Dec(S: string; B: Byte): Longint;
var
  I, P: Longint;
begin
  I := Length(S);
  Result := 0;
  S := UpperCase(S);
  P := 1;
  while (I >= 1) do begin
    if S[I] > '@' then Result := Result + (Ord(S[I]) - 55) * P
    else Result := Result + (Ord(S[I]) - 48) * P;
    Dec(I);
    P := P * B;
  end;
end;

function IntToBin(Value: Longint; Digits: Integer): string;
begin
  Result := '';
  if Digits > 32 then Digits := 32;
  while Digits > 0 do begin
    Dec(Digits);
    Result := Result + IntToStr((Value shr Digits) and 1);
  end;
end;

function StringImage(ABaseType: TBaseType; AValue: Cardinal; ADigitCount: byte): string;
begin
  case ABaseType of
    btBinary:
      Result := IntToBin(AValue,ADigitCount);
    btHexadecimal:
    begin
      Result := IntToHex(AValue,0);
      Result := StringOfChar('0',ADigitCount - Length(Result)) + Result;
    end;
    btDecimal:
    begin
      Result := IntToStr(AValue);
      Result := StringOfChar('0',ADigitCount - Length(Result)) + Result;
    end;
  end;
end;

procedure GetDigitImage(const AOldChar, ANewChar: char; ADigitImage, ADigits: TBitmap; AProgress: byte;
                        AValue, ALimit: Cardinal; AIncreasing: boolean; ABaseType: TBaseType; AIncreaseTopToBottom: boolean);
const
  DIGITS = '0123456789ABCDEF';
var
  rSrc, rDst: TRect;
  iOld, iNew, iPixelProgress: integer;
  MaxIndex: byte;
begin
  iPixelProgress := (ADigitImage.Height * AProgress) div MaxByte;
  if ABaseType = btBinary then
    MaxIndex := 1
  else if ABaseType = btHexadecimal then
    MaxIndex := 15
  else
    MaxIndex := 9;
  iNew := Pos(ANewChar,DIGITS) - 1;
  if iNew < 0 then
    iNew := 16;
  iOld := Pos(AOldChar,DIGITS) - 1;
  if iOld < 0 then
    iOld := 16;
  rSrc.Left := 0;
  rSrc.Right := ADigits.Width;
  if (iOld = 0) and ((iNew = MaxIndex) or (AValue = ALimit)) and (not AIncreasing) then { 0 -> F }
  begin
    rDst.Left := 0;
    rDst.Right := ADigits.Width;
    if AIncreaseTopToBottom then
    begin
      // Draw old digit part
      rSrc.Top := ADigitImage.Height * iOld + iPixelProgress;
      rSrc.Bottom := ADigitImage.Height * iOld + ADigitImage.Height;
      rDst.Top := 0;
      rDst.Bottom := ADigitImage.Height - iPixelProgress;
      ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
      // Draw new digit part
      rSrc.Top := ADigitImage.Height * iNew;
      rSrc.Bottom := rSrc.Top + iPixelProgress;
      rDst.Top := ADigitImage.Height - iPixelProgress;
      rDst.Bottom := ADigitImage.Height;
      ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
    end
    else
    begin
      // Draw old digit part
      rSrc.Top := ADigitImage.Height * iOld;
      rSrc.Bottom := rSrc.Top + ADigitImage.Height - iPixelProgress;
      rDst.Top := iPixelProgress;
      rDst.Bottom := ADigitImage.Height;
      ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
      // Draw new digit part
      rSrc.Top := ADigitImage.Height * iNew + (ADigitImage.Height - iPixelProgress);
      rSrc.Bottom := rSrc.Top + iPixelProgress;
      rDst.Top := 0;
      rDst.Bottom := iPixelProgress;
      ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
    end;
  end
  else if ((iOld = MaxIndex) or (AValue = 0)) and (iNew = 0) and AIncreasing then { F -> 0 }
  begin
    rDst.Left := 0;
    rDst.Right := ADigits.Width;
    if AIncreaseTopToBottom then
    begin
      // Draw new digit part
      rSrc.Top := ADigitImage.Height - iPixelProgress;
      rSrc.Bottom := rSrc.Top + iPixelProgress;
      rDst.Top := 0;
      rDst.Bottom := iPixelProgress;
      ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
      // Draw old digit part
      rSrc.Top := ADigitImage.Height * iOld;
      rSrc.Bottom := (rSrc.Top + ADigitImage.Height) - iPixelProgress;
      rDst.Top := iPixelProgress;
      rDst.Bottom := ADigitImage.Height;
      ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
    end
    else
    begin
      // Draw new digit part
      rSrc.Top := ADigitImage.Height * iNew;
      rSrc.Bottom := rSrc.Top + iPixelProgress;
      rDst.Top := ADigitImage.Height - iPixelProgress;
      rDst.Bottom := ADigitImage.Height;
      ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
      // Draw old digit part
      rSrc.Top := ADigitImage.Height * iOld + iPixelProgress;
      rSrc.Bottom := rSrc.Top + ADigitImage.Height - iPixelProgress;
      rDst.Top := 0;
      rDst.Bottom := ADigitImage.Height - iPixelProgress;
      ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
    end;
  end
  else if Abs(iNew - iOld) = 1 then
  begin
    if AIncreaseTopToBottom then
    begin
      rDst.Left := 0;
      rDst.Right := ADigits.Width;
      if iNew > iOld then
      begin
        // Draw new digit part
        rSrc.Top := iNew * ADigitImage.Height + (ADigitImage.Height - iPixelProgress);
        rSrc.Bottom := rSrc.Top + iPixelProgress;
        rDst.Top := 0;
        rDst.Bottom := iPixelProgress;
        ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
        // Draw old digit part
        rSrc.Top := ADigitImage.Height * iOld;
        rSrc.Bottom := (rSrc.Top + ADigitImage.Height) - iPixelProgress;
        rDst.Top := iPixelProgress;
        rDst.Bottom := ADigitImage.Height;
        ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
      end
      else
      begin
        // Draw new digit part
        rSrc.Top := iNew * ADigitImage.Height;
        rSrc.Bottom := rSrc.Top + iPixelProgress;
        rDst.Top := ADigitImage.Height - iPixelProgress;
        rDst.Bottom := ADigitImage.Height;
        ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
        // Draw old digit part
        rSrc.Top := ADigitImage.Height * iOld + iPixelProgress;
        rSrc.Bottom := rSrc.Top + ADigitImage.Height - iPixelProgress;
        rDst.Top := 0;
        rDst.Bottom := ADigitImage.Height - iPixelProgress;
        ADigitImage.Canvas.CopyRect(rDst,ADigits.Canvas,rSrc);
      end;
    end
    else
    begin
      if iNew > iOld then
        rSrc.Top := (ADigitImage.Height * iOld) + iPixelProgress
      else
        rSrc.Top := (ADigitImage.Height * iOld) - iPixelProgress;
      rSrc.Bottom := rSrc.Top + ADigitImage.Height;
      ADigitImage.Canvas.CopyRect(ADigitImage.Canvas.ClipRect,ADigits.Canvas,rSrc);
    end;
  end
  else
  begin
    rSrc.Top := ADigitImage.Height * iNew;
    rSrc.Bottom := rSrc.Top + ADigitImage.Height;
    ADigitImage.Canvas.CopyRect(ADigitImage.Canvas.ClipRect,ADigits.Canvas,rSrc);
  end;
end;

{================================ TOdometer ===================================}
{------------------------- Private methods -------------------------}
procedure TOdometer.Draw;
var
  rSrc, rDst: TRect;
  i: integer;
  s: string;
begin
  s := StringImage(FBaseType,FValue,FDigitCount);
  for i := 0 to FDigitCount-1 do
  begin
    GetDigitImage(' ',
                  s[i+1],
                  FBitmap,
                  FDigits,
                  MaxByte,
                  FValue,
                  FLimit,
                  True,
                  FBaseType,
                  FIncTopToBottom);
    rSrc.Left := 0;
    rSrc.Top := 0;
    rSrc.Right := FBitmap.Width;
    rSrc.Bottom := FBitmap.Height;
    rDst.Left := FBitmap.Width * i;
    rDst.Top := 0;
    rDst.Right := rDst.Left + FBitmap.Width;
    rDst.Bottom := FBitmap.Height;
    FDisplay.Canvas.CopyRect(rDst,FBitmap.Canvas,rSrc);
  end;
  Invalidate;
end;

procedure TOdometer.DrawAnimated(const AOldValue, ANewValue: string; AIncreasing: boolean);
var
  i: integer;
begin
  FFrameNo := 0;
  FOldValue := AOldValue;
  FNewValue := ANewValue;
  FIncreasing := AIncreasing;
  repeat
    i := FFrameNo;
    TimerEvent(FTimer);
    sleep(FTimer.Interval);
  until i = FFrameNo;
end;

procedure TOdometer.StartTimerAni(const AOldValue, ANewValue: string; AIncreasing: boolean);
begin
  FFrameNo := 0;
  FOldValue := AOldValue;
  FNewValue := ANewValue;
  FIncreasing := AIncreasing;
  FTimer.Enabled := True;
end;

procedure TOdometer.TimerEvent(Sender: TObject);
var
  rSrc, rDst: TRect;
  i: integer;
begin
  // Paint animated digits
  for i := 0 to FDigitCount-1 do
  begin
    GetDigitImage(FOldValue[i+1],
                  FNewValue[i+1],
                  FBitmap,
                  FDigits,
                  (FFrameNo * MaxByte) div FDisplay.Height,
                  FValue,
                  FLimit,
                  FIncreasing,
                  FBaseType,
                  FIncTopToBottom);
    rSrc.Left := 0;
    rSrc.Top := 0;
    rSrc.Right := FBitmap.Width;
    rSrc.Bottom := FBitmap.Height;
    rDst.Left := FBitmap.Width * i;
    rDst.Top := 0;
    rDst.Right := rDst.Left + FBitmap.Width;
    rDst.Bottom := FBitmap.Height;
    FDisplay.Canvas.CopyRect(rDst,FBitmap.Canvas,rSrc);
  end;
  Paint;
  if FFrameNo >= FDisplay.Height then
    TTimer(Sender).Enabled := False
  else
    inc(FFrameNo);
end;

procedure TOdometer.UpdateLimit;
begin
  case FBaseType of
    btBinary:
    begin
      if FDigitCount >= 32 then
        FLimit := MAXINT
      else
        FLimit := Numb2Dec(StringOfChar('1',FDigitCount),2);
    end;
    btHexadecimal:
      if FDigitCount >= 8 then
        FLimit := MAXINT
      else
        FLimit := StrToInt('$' + StringOfChar('F',FDigitCount));
    btDecimal:
    begin
      if FDigitCount >= 10 then
        FLimit := MAXINT
      else
        FLimit := StrToInt(StringOfChar('9',FDigitCount));
    end;
  end;
end;

{------------------------- Public methods -------------------------}
constructor TOdometer.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csFixedWidth,csFixedHeight,csReplicatable];
  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := TimerEvent;
  FTimer.Interval := 30;
  FAnimationType := atSynchronous;
  FBaseType := btDecimal;
  FDigits := TBitmap.Create;
  FDigits.LoadFromResourceName(HInstance, 'DIGITS');
  FDigitHeight := FDigits.Height div 17;
  FBitmap := TBitmap.Create;
  FBitmap.Height := FDigitHeight;
  FBitmap.Width := FDigits.Width;
  inherited Height := FDigitHeight;
  FDisplay := TBitmap.Create;
  FDisplay.Height := FDigitHeight;
  SetDigitCount(8);
  UpdateLimit;
  Draw;
end;

destructor TOdometer.Destroy;
begin
  FTimer.Free;
  FDisplay.Free;
  FBitmap.Free;
  FDigits.Free;
  inherited;
end;

procedure TOdometer.Paint;
begin
  Canvas.CopyRect(Canvas.ClipRect,FDisplay.Canvas,Canvas.ClipRect);
end;

procedure TOdometer.Increase;
var
  sOld: string;
begin
  FTimer.Enabled := False;
  sOld := StringImage(FBaseType,FValue,FDigitCount);
  if FValue = FLimit then
    FValue := 0
  else
    inc(FValue);
  case FAnimationType of
    atNone: Draw;
    atSynchronous: DrawAnimated(sOld,StringImage(FBaseType,FValue,FDigitCount),True);
    atAsynchronous: StartTimerAni(sOld,StringImage(FBaseType,FValue,FDigitCount),True);
  end;
end;

procedure TOdometer.Decrease;
var
  sOld: string;
begin
  FTimer.Enabled := False;
  sOld := StringImage(FBaseType,FValue,FDigitCount);
  if FValue = 0 then
    FValue := FLimit
  else
    dec(FValue);
  case FAnimationType of
    atNone: Draw;
    atSynchronous: DrawAnimated(sOld,StringImage(FBaseType,FValue,FDigitCount),False);
    atAsynchronous: StartTimerAni(sOld,StringImage(FBaseType,FValue,FDigitCount),False);
    {TAniThread.Create(self,sOld,StringImage(FBaseType,FValue,FDigitCount),False,FDigitCount,FDigitHeight,
                       FDigits,FDisplay,FValue,FLimit,FBaseType)}
  end;
end;

{------------------------- Protected methods -------------------------}
function TOdometer.GetHeight: Integer;
begin
  Result := inherited Height;
end;

function TOdometer.GetWidth: Integer;
begin
  Result := inherited Width;
end;

procedure TOdometer.SetBaseType(AValue: TBaseType);
begin
  if (AValue <> FBaseType) then
  begin
    FTimer.Enabled := False;
    FBaseType := AValue;
    UpdateLimit;
    SetValue(FValue);
  end;
end;

procedure TOdometer.SetDigitCount(AValue: byte);
begin
  if (AValue <> FDigitCount) and (AValue > 0) and (AValue <= 32) then
  begin
    FTimer.Enabled := False;
    FDigitCount := AValue;
    inherited Width := FDigitCount * FDigits.Width;
    FDisplay.Width := Width;
    UpdateLimit;
    SetValue(FValue);
  end;
end;

function TOdometer.GetFrameInterval: byte;
begin
  Result := FTimer.Interval;
end;

procedure TOdometer.SetFrameInterval(AValue: byte);
begin
  if AValue = 0 then
    inc(AValue);
  if AValue <> FTimer.Interval then
    FTimer.Interval := AValue;
end;

procedure TOdometer.SetValue(AValue: Cardinal);
begin
  if AValue > FLimit then
    AValue := AValue mod FLimit;
  FTimer.Enabled := False;
  if (FValue < FLimit) and (AValue = (FValue + 1)) then
    Increase
  else if (FValue > 0) and (AValue = (FValue - 1)) then
    Decrease
  else
  begin
    FValue := AValue;
    Draw;
  end;
end;

end.
