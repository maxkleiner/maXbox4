unit ImageHistogram;

interface

uses
  Graphics;

type
  THistogramArray = array[0..255] of Cardinal;
  THistogramChannel = (hclGray, hclRed, hclGreen, hclBlue);
  THistogram = class
  private
    FChannels: array[THistogramChannel] of THistogramArray;
    FPixels: Cardinal;
    function GetChannel(Index: THistogramChannel): THistogramArray;
  public
    constructor Create(Bmp: TBitmap); overload;
    procedure Init(Bmp: TBitmap);
    property Channel[Index: THistogramChannel]: THistogramArray read GetChannel; default;
    property Pixels: Cardinal read FPixels;
  end;

procedure AdjustBitmap(Bmp: TBitmap; Channel: THistogramChannel = hclGray;
                        Tolerance: Cardinal = 0); overload;
procedure AdjustBitmap(Bmp: TBitmap; Hist: THistogram; Channel: THistogramChannel = hclGray;
                        Tolerance: Cardinal = 0); overload;
procedure AdjustBitmap(Bmp: TBitmap; Low, High: Byte; Channel: THistogramChannel = hclGray); overload;

implementation

type
  TRGBTriple = array[0..2] of Byte;

constructor THistogram.Create(Bmp: TBitmap);
begin
  Create;
  Init(Bmp);
end;

function THistogram.GetChannel(Index: THistogramChannel): THistogramArray;
begin
  Result := FChannels[Index];
end;

procedure THistogram.Init(Bmp: TBitmap);
var
  RGB: ^TRGBTriple;
  X, Y: Integer;
  C: THistogramChannel;
begin
  FPixels := Bmp.Width * Bmp.Height;
  FillChar(FChannels, SizeOf(FChannels), #0);

  for Y := 0 to Bmp.Height - 1 do
  begin
    RGB := Bmp.ScanLine[Y];
    for X := 0 to Bmp.Width - 1 do
    begin
      for C := hclRed to hclBlue do
        Inc(FChannels[C][RGB[3 - Byte(C)]]);
      Inc(FChannels[hclGray][(RGB[0] + RGB[1] + RGB[2]) div 3]);
      Inc(RGB);
    end;
  end;
end;


procedure AdjustBitmap(Bmp: TBitmap; Channel: THistogramChannel = hclGray;
                        Tolerance: Cardinal = 0);
var
  Hist: THistogram;
begin
  Hist := THistogram.Create;
  try
    Hist.Init(Bmp);
    AdjustBitmap(Bmp, Hist, Channel, Tolerance);
  finally
    Hist.Free;
  end;
end;

procedure AdjustBitmap(Bmp: TBitmap; Hist: THistogram; Channel: THistogramChannel = hclGray;
                        Tolerance: Cardinal = 0);
var
  L, H, X: Byte;
begin
  L := 0;
  for X := 0 to 255 do
    if Hist[hclGray][X] > Tolerance then Break
    else Inc(L);
  H := 255;
  for X := 255 downto 0 do
    if Hist[hclGray][X] > Tolerance then Break
    else Dec(H);
  AdjustBitmap(Bmp, L, H, Channel);
end;

procedure AdjustBitmap(Bmp: TBitmap; Low, High: Byte; Channel: THistogramChannel = hclGray);
  function M(B: Smallint): Byte;
  begin
    if B < 0 then Result := 0
    else if B > 255 then Result := 255
    else Result := B;
  end;
var
  RGB: ^TRGBTriple;
  X, Y, W, H: Integer;
  Z: Byte;
begin
  Dec(High, Low);
  if High <= 0 then
    Exit;
    
  W := Bmp.Width - 1;
  H := Bmp.Height - 1;
  if Channel = hclGray then
  begin
    for Y := 0 to H do
    begin
      RGB := Bmp.ScanLine[Y];
      for X := 0 to W do
      begin
        for Z := 0 to 2 do
          RGB[Z] := M((RGB[Z] - Low) * 255 div High);
        Inc(RGB);
      end;
    end;
  end
  else
  begin
    Z := 3 - Byte(Channel);
    for Y := 0 to H do
    begin
      RGB := Bmp.ScanLine[Y];
      for X := 0 to W do
      begin
        RGB[Z] := M((RGB[Z] - Low) * 255 div High);
        Inc(RGB);
      end;
    end;
  end;
end;

end.
