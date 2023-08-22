{------------------------------------------------------------------------------}
{                                                                              }
{  TRotateImage v1.54                                                          }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

{$I DELPHIAREA.INC}

unit RotImg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type

  TRotateImage = class(TGraphicControl)
  private
    FPicture: TPicture;
    FStretch: Boolean;
    FCenter: Boolean;
    FTransparent: Boolean;
    FProportional: Boolean;
    FAngle: Extended;
    {$IFNDEF COMPILER4_UP}
    FAutoSize: Boolean;
    {$ENDIF}
    FUniqueSize: Boolean;
    FMaxSize: Integer;
    FBitmap: TBitmap;
    FRotatedBitmap: TBitmap;
    FFreeBitmap: Boolean;
    FImageRect: TRect;
    FImageRgn: HRGN;
    FCalcMetrics: Byte;
    FChanging: Boolean;
    FOnRotation: TNotifyEvent;
    function GetCanvas: TCanvas;
    procedure PictureChanged(Sender: TObject);
    procedure SetCenter(Value: Boolean);
    procedure SetPicture(Value: TPicture);
    procedure SetStretch(Value: Boolean);
    procedure SetProportional(Value: Boolean);
    procedure SetTransparent(Value: Boolean);
    procedure SetAngle(Value: Extended);
    {$IFNDEF COMPILER4_UP}
    procedure SetAutoSize(Value: Boolean);
    {$ENDIF}
    procedure SetUniqueSize(Value: Boolean);
    function GetImageRect: TRect;
    function GetImageRgn: HRGN;
  protected
    {$IFDEF COMPILER4_UP}
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    {$ELSE}
    procedure AdjustSize;
    {$ENDIF}
    procedure RebuildBitmap;
    procedure RebuildRotatedBitmap;
    procedure CalcImageRect;
    procedure CalcImageRgn;
    procedure Paint; override;
    procedure Loaded; override;
    {$IFDEF COMPILER4_UP}
    procedure Resize; override;
    {$ELSE}
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    {$ENDIF}
    procedure DoRotation; virtual;
    property Bitmap: TBitmap read FBitmap;
    property FreeBitmap: Boolean read FFreeBitmap;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function RotatedPoint(const Pt: TPoint): TPoint;
    procedure RotatePoints(var Points: array of TPoint);
    property Canvas: TCanvas read GetCanvas;
    property RotatedBitmap: TBitmap read FRotatedBitmap;
    property MaxSize: Integer read FMaxSize;
    property ImageRect: TRect read GetImageRect;
    property ImageRgn: HRGN read GetImageRgn;
  published
    property Align;
    {$IFDEF COMPILER4_UP}
    property Anchors;
    {$ENDIF}
    property Angle: Extended read FAngle write SetAngle;
    {$IFDEF COMPILER4_UP}
    property AutoSize;
    {$ELSE}
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    {$ENDIF}
    property Center: Boolean read FCenter write SetCenter default False;
    property Color;
    {$IFDEF COMPILER4_UP}
    property Constraints;
    {$ENDIF}
    property DragCursor;
    {$IFDEF COMPILER4_UP}
    property DragKind;
    {$ENDIF}
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property Picture: TPicture read FPicture write SetPicture;
    property PopupMenu;
    property Proportional: Boolean read FProportional write setProportional default False;
    property ShowHint;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property UniqueSize: Boolean read FUniqueSize write SetUniqueSize default True;
    property Visible;
    {$IFDEF COMPILER4_UP}
    property OnCanResize;
    {$ENDIF}
    property OnClick;
    {$IFDEF COMPILER4_UP}
    property OnConstrainedResize;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF COMPILER4_UP}
    property OnEndDock;
    {$ENDIF}
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    {$IFDEF COMPILER4_UP}
    property OnResize;
    {$ENDIF}
    property OnRotation: TNotifyEvent read FOnRotation write FOnRotation;
    {$IFDEF COMPILER4_UP}
    property OnStartDock;
    {$ENDIF}
    property OnStartDrag;
  end;

function CreateRotatedBitmap(Bitmap: TBitmap; const Angle: Extended; bgColor: TColor): TBitmap;

implementation

uses
  Consts, Math;

const
  CM_NONE   = 0;
  CM_BOUNDS = $01;
  CM_REGION = $02;

// Transforms a set of points
procedure XFormPoints(var Points: array of TPoint; const XForm: TXForm);
var
  I: Integer;
begin
  for I := Low(Points) to High(Points) do
    with Points[I], XForm do
    begin
      X := Round(X * eM11 + Y * eM21 + eDx);
      Y := Round(X * eM12 + Y * eM22 + eDy);
    end;
end;

// Creates rotated bitmap of the specified bitmap.
function CreateRotatedBitmap(Bitmap: TBitmap; const Angle: Extended; bgColor: TColor): TBitmap;
type
  PRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array[0..0] of TRGBQuad;
var
  bgRGB: TRGBQuad;
  NormalAngle: Extended;
  CosTheta, SinTheta: Extended;
  iCosTheta, iSinTheta: Integer;
  xSrc, ySrc: Integer;
  xDst, yDst: Integer;
  xODst, yODst: Integer;
  xOSrc, yOSrc: Integer;
  xPrime, yPrime: Integer;
  srcWidth, srcHeight: Integer;
  dstWidth, dstHeight: Integer;
  yPrimeSinTheta, yPrimeCosTheta: Integer;
  srcRGBs: PRGBQuadArray;
  dstRGBs: PRGBQuadArray;
  dstRGB: PRGBQuad;
  BitmapInfo: TBitmapInfo;
  srcBMP, dstBMP: HBITMAP;
  DC: HDC;
begin
  { Converts bgColor to true RGB Color }
  bgColor := ColorToRGB(bgColor);
  with bgRGB do
  begin
    rgbRed := Byte(bgColor);
    rgbGreen := Byte(bgColor shr 8);
    rgbBlue := Byte(bgColor shr 16);
    rgbReserved := Byte(bgColor shr 24);
  end;

  { Calculates Sine and Cosine of the rotation angle }
  NormalAngle := Frac(Angle / 360.0) * 360.0;
  SinCos(Pi * -NormalAngle / 180, SinTheta, CosTheta);
  iSinTheta := Trunc(SinTheta * (1 shl 16));
  iCosTheta := Trunc(CosTheta * (1 shl 16));

  { Prepares the required data for the source bitmap }
  srcBMP := Bitmap.Handle;
  srcWidth := Bitmap.Width;
  srcHeight := Bitmap.Height;
  xOSrc := srcWidth shr 1;
  yOSrc := srcHeight shr 1;

  { Prepares the required data for the target bitmap }
  dstWidth := SmallInt((srcWidth * Abs(iCosTheta) + srcHeight * Abs(iSinTheta)) shr 16);
  dstHeight := SmallInt((srcWidth * Abs(iSinTheta) + srcHeight * Abs(iCosTheta)) shr 16);
  xODst := dstWidth shr 1;
  if not Odd(dstWidth) and ((NormalAngle = 0.0) or (NormalAngle = -90.0)) then
    Dec(xODst);
  yODst := dstHeight shr 1;
  if not Odd(dstHeight) and ((NormalAngle = 0.0) or (NormalAngle = +90.0)) then
    Dec(yODst);

  // Initializes bitmap header
  FillChar(BitmapInfo, SizeOf(BitmapInfo), 0);
  with BitmapInfo.bmiHeader do
  begin
    biSize := SizeOf(BitmapInfo.bmiHeader);
    biCompression := BI_RGB;
    biBitCount := 32;
    biPlanes := 1;
  end;

  // Get source and target RGB bits
  DC := CreateCompatibleDC(0);
  try
    BitmapInfo.bmiHeader.biWidth := srcWidth;
    BitmapInfo.bmiHeader.biHeight := srcHeight;
    GetMem(srcRGBs, srcWidth * srcHeight * SizeOf(TRGBQuad));
    GdiFlush;
    GetDIBits(DC, srcBMP, 0, srcHeight, srcRGBS, BitmapInfo, DIB_RGB_COLORS);
    BitmapInfo.bmiHeader.biWidth := dstWidth;
    BitmapInfo.bmiHeader.biHeight := dstHeight;
    dstBMP := CreateDIBSection(DC, BitmapInfo, DIB_RGB_COLORS, Pointer(dstRGBs), 0, 0);
  finally
    DeleteDC(DC);
  end;

  { Pefroms rotation on RGB bits }
  dstRGB := @dstRGBs[(dstWidth * dstHeight) - 1];
  yPrime := yODst;
  for yDst := dstHeight - 1 downto 0 do
  begin
    yPrimeSinTheta := yPrime * iSinTheta;
    yPrimeCosTheta := yPrime * iCosTheta;
    xPrime := xODst;
    for xDst := dstWidth - 1 downto 0 do
    begin
      xSrc := SmallInt((xPrime * iCosTheta - yPrimeSinTheta) shr 16) + xOSrc;
      ySrc := SmallInt((xPrime * iSinTheta + yPrimeCosTheta) shr 16) + yOSrc;
      {$IFDEF COMPILER4_UP}
      if (DWORD(ySrc) < DWORD(srcHeight)) and (DWORD(xSrc) < DWORD(srcWidth)) then
      {$ELSE} // Delphi 3 compiler ignores unsigned type cast and generates signed comparison code!
      if (ySrc >= 0) and (ySrc < srcHeight) and (xSrc >= 0) and (xSrc < srcWidth) then
      {$ENDIF}
        dstRGB^ := srcRGBs[ySrc * srcWidth + xSrc]
      else
        dstRGB^ := bgRGB;
      Dec(dstRGB);
      Dec(xPrime);
    end;
    Dec(yPrime);
  end;

  { Releases memory for source bitmap RGB bits }
  FreeMem(srcRGBs);

  { Create result bitmap }
  Result := TBitmap.Create;
  Result.Handle := dstBMP;
end;

// Returns rotated coordinates of a point on the original image
function TRotateImage.RotatedPoint(const Pt: TPoint): TPoint;
var
  NormalAngle: Extended;
  CosTheta, SinTheta: Extended;
  Prime, OrgDst, OrgSrc: TPoint;
begin
  NormalAngle := Frac(Angle / 360.0) * 360.0;
  SinCos(Pi * -NormalAngle / 180, SinTheta, CosTheta);

  OrgDst.X := RotatedBitmap.Width div 2;
  if not Odd(RotatedBitmap.Width) and ((NormalAngle = 0.0) or (NormalAngle = -90.0)) then
    Dec(OrgDst.X);
  OrgDst.Y := RotatedBitmap.Height div 2;
  if not Odd(RotatedBitmap.Height) and ((NormalAngle = 0.0) or (NormalAngle = +90.0)) then
    Dec(OrgDst.Y);

  OrgSrc.X := Picture.Width div 2;
  OrgSrc.Y := Picture.Height div 2;

  Prime.X := Pt.X - OrgSrc.X;
  Prime.Y := Pt.Y - OrgSrc.Y;

  Result.X := Round(Prime.X * CosTheta - Prime.Y * SinTheta) + OrgDst.X;
  Result.Y := Round(Prime.X * SinTheta + Prime.Y * CosTheta) + OrgDst.Y;
end;

// Rotates a set of points on the original image
procedure TRotateImage.RotatePoints(var Points: array of TPoint);
var
  NormalAngle: Extended;
  CosTheta, SinTheta: Extended;
  Prime, OrgDst, OrgSrc: TPoint;
  I: Integer;
begin
  NormalAngle := Frac(Angle / 360.0) * 360.0;
  SinCos(Pi * -NormalAngle / 180, SinTheta, CosTheta);

  OrgDst.X := RotatedBitmap.Width div 2;
  if not Odd(RotatedBitmap.Width) and ((NormalAngle = 0.0) or (NormalAngle = -90.0)) then
    Dec(OrgDst.X);
  OrgDst.Y := RotatedBitmap.Height div 2;
  if not Odd(RotatedBitmap.Height) and ((NormalAngle = 0.0) or (NormalAngle = +90.0)) then
    Dec(OrgDst.Y);

  OrgSrc.X := Picture.Width div 2;
  OrgSrc.Y := Picture.Height div 2;

  for I := Low(Points) to High(Points) do
    with Points[I] do
    begin
      Prime.X := X - OrgSrc.X;
      Prime.Y := Y - OrgSrc.Y;
      X := Round(Prime.X * CosTheta - Prime.Y * SinTheta) + OrgDst.X;
      Y := Round(Prime.X * SinTheta + Prime.Y * CosTheta) + OrgDst.Y;
    end;
end;

procedure TRotateImage.RebuildBitmap;
var
  G: TGraphic;
  OrgBitmap: TBitmap;
begin
  OrgBitmap := nil;
  G := Picture.Graphic;
  if Assigned(G) and not G.Empty then
  begin
    if G is TBitmap then
      OrgBitmap := TBitmap(G)
    else
    begin
      OrgBitmap := TBitmap.Create;
      OrgBitmap.Canvas.Brush.Color := Color;
      OrgBitmap.Width := G.Width;
      OrgBitmap.Height := G.Height;
      OrgBitmap.PixelFormat := pf32bit;
      OrgBitmap.Canvas.Draw(0, 0, G);
      OrgBitmap.TransparentColor := OrgBitmap.Canvas.Brush.Color;
      OrgBitmap.Transparent := G.Transparent;
    end;
  end;
  if Assigned(Bitmap) and FFreeBitmap then
    FBitmap.Free;
  FBitmap := OrgBitmap;
  FFreeBitmap := Assigned(OrgBitmap) and (OrgBitmap <> G);
end;

procedure TRotateImage.RebuildRotatedBitmap;
var
  RotBitmap: TBitmap;
  BackColor: TColor;
begin
  if Assigned(FBitmap) then
  begin
    BackColor := FBitmap.TransparentColor and not $02000000;
    RotBitmap := CreateRotatedBitmap(FBitmap, FAngle, BackColor);
    RotBitmap.TransparentColor := BackColor;
    RotBitmap.Transparent := FBitmap.Transparent;
    FRotatedBitmap.Free;
    FRotatedBitmap := RotBitmap;
  end
  else
  begin
    FRotatedBitmap.Width := 0;
    FRotatedBitmap.Height := 0;
  end;
end;

procedure TRotateImage.CalcImageRect;
var
  iW, iH, cW, cH, dW, dH: Integer;
begin
  dW := 0;
  dH := 0;
  if UniqueSize then
  begin
    iW := MaxSize;
    iH := MaxSize;
  end
  else
  begin
    iW := RotatedBitmap.Width;
    iH := RotatedBitmap.Height;
  end;
  cW := ClientWidth;
  cH := ClientHeight;
  if Stretch or (Proportional and ((iW > cW) or (iH > cH))) then
  begin
    if Proportional and (iW > 0) and (iH > 0) then
    begin
      if (cW / iW) < (cH / iH) then
      begin
        iH := MulDiv(iH, cW, iW);
        iW := cW;
      end
      else
      begin
        iW := MulDiv(iW, cH, iH);
        iH := cH;
      end;
    end
    else
    begin
      iW := cW;
      iH := cH;
    end;
  end;
  if UniqueSize and (MaxSize <> 0) then
  begin
    dW := MulDiv(MaxSize - RotatedBitmap.Width, iW, MaxSize);
    dH := MulDiv(MaxSize - RotatedBitmap.Height, iH, MaxSize);
    Dec(iW, dW);
    Dec(iH, dH);
  end;
  with FImageRect do
  begin
    Left := 0;
    Top := 0;
    Right := iW;
    Bottom := iH;
  end;
  if Center then
    OffsetRect(FImageRect, (cW - iW) div 2, (cH - iH) div 2)
  else if UniqueSize and (MaxSize > 0) then
    OffsetRect(FImageRect, dW div 2, dH div 2);
end;

procedure TRotateImage.CalcImageRgn;
var
  Corners: array[1..4] of TPoint;
  XForm: TXForm;
begin
  if FImageRgn <> 0 then
  begin
    DeleteObject(FImageRgn);
    FImageRgn := 0;
  end;
  if Assigned(Bitmap) then
  begin
    with Bitmap do
    begin
      with Corners[1] do begin X := 0; Y := 0; end;
      with Corners[2] do begin X := Width; Y := 0; end;
      with Corners[3] do begin X := Width; Y := Height; end;
      with Corners[4] do begin X := 0; Y := Height; end;
    end;
    with XForm, ImageRect, RotatedBitmap do
    begin
      eM11 := (Right - Left) / Width;
      eM12 := 0;
      eM21 := 0;
      eM22 := (Bottom - Top) / Height;
      eDX := Self.Left + Left - (Right - Left - eM11 * Width) / 2.0;
      eDY := Self.Top + Top - (Bottom - Top - eM22 * Height) / 2.0;
    end;
    RotatePoints(Corners);
    XFormPoints(Corners, XForm);
    FImageRgn := CreatePolygonRgn(Corners, 4, ALTERNATE);
  end;
end;

constructor TRotateImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FRotatedBitmap := TBitmap.Create;
  FUniqueSize := True;
  Height := 105;
  Width := 105;
end;

destructor TRotateImage.Destroy;
begin
  if FImageRgn <> 0 then
  begin
    DeleteObject(FImageRgn);
    FImageRgn := 0;
  end;
  if Assigned(FBitmap) and FFreeBitmap then
    FBitmap.Free;
  FBitmap := nil;
  FRotatedBitmap.Free;
  FRotatedBitmap := nil;
  FPicture.Free;
  inherited Destroy;
end;

procedure TRotateImage.Paint;
var
  SavedDC: Integer;
begin
  if not RotatedBitmap.Empty then
    with inherited Canvas do
    begin
      if RotatedBitmap.Transparent then
        StretchDraw(ImageRect, RotatedBitmap)
      else
      begin
        SavedDC := SaveDC(Handle);
        try
          SelectClipRgn(Handle, ImageRgn);
          IntersectClipRect(Handle, 0, 0, Width, Height);
          StretchDraw(ImageRect, RotatedBitmap);
        finally
          RestoreDC(Handle, SavedDC);
        end;
      end;
    end;
  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;

procedure TRotateImage.Loaded;
begin
  inherited Loaded;
  PictureChanged(Self);
end;


{$IFDEF COMPILER4_UP}
procedure TRotateImage.Resize;
begin
  FCalcMetrics := CM_NONE;
  inherited Resize;
end;
{$ENDIF}

{$IFNDEF COMPILER4_UP}
procedure TRotateImage.SetBounds(ALeft, ATop, AWidth, AHeight: Integer); 
begin
  FCalcMetrics := CM_NONE;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;
{$ENDIF}

function TRotateImage.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  if Picture.Graphic = nil then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      Picture.Graphic := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;
  if Picture.Graphic is TBitmap then
    Result := TBitmap(Picture.Graphic).Canvas
  else
    raise EInvalidOperation.Create(SImageCanvasNeedsBitmap);
end;

function TRotateImage.GetImageRect: TRect;
begin
  if not ByteBool(FCalcMetrics and CM_BOUNDS) then
  begin
    CalcImageRect;
    FCalcMetrics := FCalcMetrics or CM_BOUNDS;
  end;
  Result := FImageRect;
end;

function TRotateImage.GetImageRgn: HRGN;
begin
  if not ByteBool(FCalcMetrics and CM_REGION) then
  begin
    CalcImageRgn;
    FCalcMetrics := FCalcMetrics or CM_REGION;
  end;
  Result := FImageRgn;
end;

procedure TRotateImage.SetCenter(Value: Boolean);
begin
  if Value <> Center then
  begin
    FCenter := Value;
    FCalcMetrics := CM_NONE;
    Invalidate;
  end;
end;

procedure TRotateImage.SetPicture(Value: TPicture);
begin
  Picture.Assign(Value);
end;

procedure TRotateImage.SetStretch(Value: Boolean);
begin
  if Value <> Stretch then
  begin
    FStretch := Value;
    FCalcMetrics := CM_NONE;
    Invalidate;
  end;
end;

procedure TRotateImage.SetProportional(Value: Boolean);
begin
  if Value <> Proportional then
  begin
    FProportional := Value;
    FCalcMetrics := CM_NONE;
    Invalidate;
  end;
end;

procedure TRotateImage.SetTransparent(Value: Boolean);
var
  G: TGraphic;
begin
  if Value <> Transparent then
  begin
    FTransparent := Value;
    G := Picture.Graphic;
    if Assigned(G) then
    begin
      if not ((G is TMetaFile) or (G is TIcon)) then
        G.Transparent := Transparent
      else
        G.Transparent := True;
      if Assigned(FBitmap) then
        FBitmap.Transparent := G.Transparent;
      if Assigned(FRotatedBitmap) then
        FRotatedBitmap.Transparent := G.Transparent;
    end;
    Invalidate;
  end;
end;

procedure TRotateImage.SetAngle(Value: Extended);
begin
  if Value <> Angle then
  begin
    FAngle := Value;
    if Assigned(Picture.Graphic) and not (csLoading in ComponentState) then
    begin
      RebuildRotatedBitmap;
      FCalcMetrics := CM_NONE;
      if AutoSize and not UniqueSize then
        AdjustSize;
      Invalidate;
      DoRotation;
    end;
  end;
end;

{$IFNDEF COMPILER4_UP}
procedure TRotateImage.SetAutoSize(Value: Boolean);
begin
  if Value <> AutoSize then
  begin
    FAutoSize := Value;
    if FAutoSize then
      AdjustSize;
  end;
end;
{$ENDIF}

procedure TRotateImage.SetUniqueSize(Value: Boolean);
begin
  if Value <> UniqueSize then
  begin
    FUniqueSize := Value;
    FCalcMetrics := CM_NONE;
    if AutoSize then
      AdjustSize;
    Invalidate;
  end;
end;

procedure TRotateImage.PictureChanged(Sender: TObject);
var
  G: TGraphic;
begin
  if not (csLoading in ComponentState) and not FChanging then
  begin
    FChanging := True;
    try
      G := Picture.Graphic;
      if G <> nil then
      begin
        if not ((G is TMetaFile) or (G is TIcon)) then
          G.Transparent := FTransparent;
        FMaxSize := Round(Sqrt(Sqr(G.Width) + Sqr(G.Height)));
      end
      else
        FMaxSize := 0;
      RebuildBitmap;
      RebuildRotatedBitmap;
      FCalcMetrics := CM_NONE;
      if AutoSize and (MaxSize <> 0) then
      begin
        if UniqueSize then
          SetBounds(Left, Top, MaxSize, MaxSize)
        else
          SetBounds(Left, Top, RotatedBitmap.Width, RotatedBitmap.Height);
      end;
    finally
      FChanging := False;
    end;
    Invalidate;
    DoRotation;
  end;
end;

{$IFDEF COMPILER4_UP}
function TRotateImage.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
  if not (csDesigning in ComponentState) or (MaxSize <> 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      if UniqueSize then
        NewWidth := MaxSize
      else
        NewWidth := RotatedBitmap.Width;
    if Align in [alNone, alTop, alBottom] then
      if UniqueSize then
        NewHeight := MaxSize
      else
        NewHeight := RotatedBitmap.Height;
  end;
end;
{$ENDIF}

{$IFNDEF COMPILER4_UP}
procedure TRotateImage.AdjustSize;
begin
  if not (csDesigning in ComponentState) or (MaxSize <> 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      if UniqueSize then
        Width := MaxSize
      else
        Width := RotatedBitmap.Width;
    if Align in [alNone, alTop, alBottom] then
      if UniqueSize then
        Height := MaxSize
      else
        Height := RotatedBitmap.Height;
  end;
end;
{$ENDIF}

procedure TRotateImage.DoRotation;
begin
  if Assigned(FOnRotation) then
    FOnRotation(Self);
end;

end.
