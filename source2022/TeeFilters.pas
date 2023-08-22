{**********************************************}
{   TeeChart and TeeTree Image Filters         }
{                                              }
{   Copyright (c) 2006-2007 by David Berneda   }
{        All Rights Reserved                   }
{**********************************************}
unit TeeFilters;
{$I TeeDefs.inc}

{$R-}

interface

uses
  {$IFNDEF LINUX}
  Windows,
  {$ENDIF}
  Classes,
  {$IFDEF D6}
  Types,
  {$ENDIF}
  {$IFDEF CLX}
  Qt, QControls, QGraphics, QStdCtrls, QExtCtrls,
  {$ELSE}
  Controls, Graphics, StdCtrls, ExtCtrls,
  {$ENDIF}
  TeCanvas, TeeConst;

{$IFDEF CLR}
{$UNSAFECODE ON}
{$ENDIF}

type
  TResizeFilter=class(TTeeFilter)
  private
    FWidth  : Integer;
    FHeight : Integer;
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;

    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property Width:Integer read FWidth write FWidth default 0;
    property Height:Integer read FHeight write FHeight default 0;
  end;

  TCropFilter=class(TResizeFilter)
  private
    FLeft   : Integer;
    FSmooth : Boolean;
    FTop    : Integer;
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;

    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property Left:Integer read FLeft write FLeft default 0;
    property Smooth:Boolean read FSmooth write FSmooth default False;
    property Top:Integer read FTop write FTop default 0;
  end;

  TInvertFilter=class(TTeeFilter)
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  end;

  TGrayMethod=(gmSimple, gmEye, gmEye2);

  TGrayScaleFilter=class(TTeeFilter)
  private
    FMethod : TGrayMethod;
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;

    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property Method:TGrayMethod read FMethod write FMethod default gmSimple;
  end;

  TFlipFilter=class(TTeeFilter)
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  end;

  TReverseFilter=class(TTeeFilter)
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  end;

  TAmountFilter=class(TTeeFilter)
  private
    FAmount  : Integer;
    FPercent : Boolean;
    FScrollBar : TScrollBar;

    IOnlyPositive : Boolean;
    procedure ResetScroll(Sender:TObject);
    function ScrollMin:Integer;
    function ScrollMax:Integer;
  public
    Constructor Create(Collection:TCollection); override;
    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
  published
    property Percent:Boolean read FPercent write FPercent default True;
    property Amount:Integer read FAmount write FAmount default 5;
  end;

  TMosaicFilter=class(TAmountFilter)
  public
    Constructor Create(Collection:TCollection); override;
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  end;

  TBrightnessFilter=class(TAmountFilter)
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  end;

  TContrastFilter=class(TAmountFilter)
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  end;

  TColorFilter=class(TTeeFilter)
  private
    FBlue  : Integer;
    FGreen : Integer;
    FRed   : Integer;
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property Red:Integer read FRed write FRed default 0;
    property Green:Integer read FGreen write FGreen default 0;
    property Blue:Integer read FBlue write FBlue default 0;
  end;

  THueLumSatFilter=class(TTeeFilter)
  private
    FHue : Integer;
    FLum : Integer;
    FSat : Integer;
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property Hue:Integer read FHue write FHue default 0;
    property Luminance:Integer read FLum write FLum default 0;
    property Saturation:Integer read FSat write FSat default 0;
  end;

  TSharpenFilter=class(TConvolveFilter)
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  end;

  TEmbossFilter=class(TConvolveFilter)
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  end;

  TSoftenFilter=class(TConvolveFilter)
  public
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  end;

  TGammaCorrectionFilter=class(TAmountFilter)
  public
    Constructor Create(Collection:TCollection); override;
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;
  published
    property Amount default 70;
  end;

  TRotateFilter=class(TTeeFilter)
  private
    FAngle     : Double;
    FAutoSize  : Boolean;
    FBackColor : TColor;
    procedure SetAngle(const Value: Double);
  public
    Constructor Create(Collection:TCollection); override;

    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property Angle:Double read FAngle write SetAngle;
    property AutoSize:Boolean read FAutoSize write FAutoSize default True;
    property BackColor:TColor read FBackColor write FBackColor default clWhite;
  end;

  TMirrorDirection=(mdDown, mdUp, mdRight, mdLeft);

  TMirrorFilter=class(TTeeFilter)
  private
    FDirection : TMirrorDirection;
  public
    Constructor Create(Collection:TCollection); override;

    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property Direction:TMirrorDirection read FDirection write FDirection
                                default mdDown;
  end;

  TTileFilter=class(TTeeFilter)
  private
    FNumCols : Integer;
    FNumRows : Integer;
  public
    Constructor Create(Collection:TCollection); override;

    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property NumCols:Integer read FNumCols write FNumCols default 3;
    property NumRows:Integer read FNumRows write FNumRows default 3;
  end;

  TBevelFilter=class(TTeeFilter)
  private
    FBright : Integer;
    FSize   : Integer;
  public
    Constructor Create(Collection:TCollection); override;

    procedure Apply(Bitmap: TBitmap; const R:TRect); override;
    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property Bright:Integer read FBright write FBright default 64;
    property Size:Integer read FSize write FSize default 15;
  end;

  TZoomFilter=class(TTeeFilter)
  private
    FPercent : Double;
    FSmooth  : Boolean;
  public
    Constructor Create(Collection:TCollection); override;

    procedure Apply(Bitmap: TBitmap; const R:TRect); override;
    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
    class function Description: String; override;
  published
    property Percent:Double read FPercent write FPercent;
    property Smooth:Boolean read FSmooth write FSmooth default False;
  end;

  TImageFiltered=class(TImage)
  private
    FFilters : TFilterItems;

    function FiltersStored:Boolean;
    procedure ReadFilters(Reader: TReader);
    procedure SetFilters(const Value: TFilterItems);
    procedure WriteFilters(Writer: TWriter);
  protected
    procedure DefineProperties(Filer:TFiler); override;
    procedure Paint; override;
  public
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    function Filtered:TBitmap;
  published
    property Filters:TFilterItems read FFilters write SetFilters stored False;
  end;

const

 TeeMsg_FunctionSubset   ='Subset';
  TeeMsg_Hexagon         ='Hexagon';
  TeeMsg_AntiAlias       ='Antialias';
  TeeMsg_Percent         ='Percent';
  TeeMsg_Smooth          ='Smooth';
  TeeMsg_Blur            ='Blur';
  TeeMsg_Width            ='Width';
  TeeMsg_Resize           ='Resize';
  TeeMsg_Left             ='Left';
  TeeMsg_Top              ='Top';
  TeeMsg_Crop             ='Crop';
  TeeMsg_Invert           ='Invert';
  TeeMsg_GrayScale        ='Gray scale';
  TeeMsg_Mosaic           ='Mosaic';
 TeeMsg_Flip             ='Flip';
  TeeMsg_Reverse          ='Reverse';
  TeeMsg_Brightness       ='Brightness';
  TeeMsg_Color            ='Color';
  TeeMsg_HueLumSat        ='Hue,Lum,Sat';
  TeeMsg_Sharpen          ='Sharpen';
  TeeMsg_GammaCorrection  ='Gamma correction';
  TeeMsg_Emboss           ='Emboss';
  TeeMsg_Contrast         ='Contrast';
  TeeMsg_Rotate           ='Rotate';
  TeeMsg_Back             ='Back';
  TeeMsg_Autosize         ='Autosize';
  TeeMsg_Mirror           ='Mirror';
  TeeMsg_Columns          ='Columns';
  TeeMsg_Rows             ='Rows';
  TeeMsg_Tile             ='Tile';
  TeeMsg_Bevel            ='Bevel';
  TeeMsg_Zoom             ='Zoom';
  TeeMsg_ThemeDefault     ='Default';
  TeeMsg_ThemeTeeChart    ='TeeChart';
  TeeMsg_ThemeExcel       ='Excel';
  TeeMsg_ThemeVictorian   ='Victorian';
  TeeMsg_ThemePastels     ='Pastels';
  TeeMsg_ThemeSolid       ='Solid';
  TeeMsg_ThemeClassic     ='Classic';
  TeeMsg_ThemeWeb         ='Web';
  TeeMsg_ThemeModern      ='Modern';
  TeeMsg_ThemeRainbow     ='Rainbow';
  TeeMsg_ThemeWinXP       ='Win. XP';
  TeeMsg_ThemeMacOS       ='Mac OS';
  TeeMsg_ThemeWinVista    ='Win. Vista';
  TeeMsg_ThemeGrayScale   ='Gray scale';
  TeeMsg_ThemeOpera       ='Opera';
  TeeMsg_ThemeWarm        ='Warm';
  TeeMsg_ThemeCool        ='Cool';


  TeeMsg_MenuFilters      ='&Filters...';
  TeeMsg_CrossTab         ='CrossTab';
  TeeMsg_DBSumEditCaption ='Summary properties';


var
  FilterClasses : TList;

procedure TeeRegisterFilters(const FilterList:Array of TFilterClass);
procedure TeeUnRegisterFilters(const FilterList:Array of TFilterClass);

procedure ColorToHLS(Color: TColor; out Hue, Luminance, Saturation: Word);
procedure RGBToHLS(const Color: TRGB; out Hue, Luminance, Saturation: Word);

procedure HLSToRGB(Hue, Luminance, Saturation: Word; out rgb: TRGB);
function HLSToColor(Hue, Luminance, Saturation: Word):TColor;

// Converts ABitmap pixels into Gray Scale (levels of gray) v5.02 (v8 moved from TeCanvas.pas)
Procedure TeeGrayScale(ABitmap:TBitmap; Inverted:Boolean; AMethod:Integer);

implementation

uses
  Math, SysUtils, TypInfo;

procedure TeeRegisterFilters(const FilterList:Array of TFilterClass);
var t : Integer;
begin
  if not Assigned(FilterClasses) then
     FilterClasses:=TList.Create;

  for t:=Low(FilterList) to High(FilterList) do
  if FilterClasses.IndexOf({$IFDEF CLR}TObject{$ENDIF}(FilterList[t]))=-1 then
  begin
    FilterClasses.Add({$IFDEF CLR}TObject{$ENDIF}(FilterList[t]));
    RegisterClass(FilterList[t]);
  end;
end;

procedure TeeUnRegisterFilters(const FilterList:Array of TFilterClass);
var t : Integer;
begin
  if Assigned(FilterClasses) then
  for t:=Low(FilterList) to High(FilterList) do
      FilterClasses.Remove({$IFDEF CLR}TObject{$ENDIF}(FilterList[t]));
end;

{ TResizeFilter }

function SmoothBitmap(Bitmap:TBitmap; Width,Height:Integer):TBitmap;
begin
  result:=TBitmap.Create;
  TeeSetBitmapSize(result,Width,Height);
  SmoothStretch(Bitmap,result);
end;

procedure TResizeFilter.Apply(Bitmap:TBitmap; const R:TRect);
var tmp : TBitmap;
begin
  if (Width>0) and (Height>0) then
  begin
    tmp:=SmoothBitmap(Bitmap,Width,Height);
    try
      TeeSetBitmapSize(Bitmap,Width,Height);
      Bitmap.Canvas.Draw(0,0,tmp);
    finally
      tmp.Free;
    end;
  end;
// Do not call inherited;
end;

procedure TResizeFilter.CreateEditor(Creator: IFormCreator;
  AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddInteger('Width',TeeMsg_Width,0,10000); // Do not localize
  Creator.AddInteger('Height',TeeMsg_Height,0,10000); // Do not localize
end;

class function TResizeFilter.Description: String;
begin
  result:=TeeMsg_Resize;
end;

{ TCropFilter }

procedure TCropFilter.Apply(Bitmap: TBitmap; const R: TRect);
var tmp : TBitmap;
begin
  if (Width>0) and (Height>0) then
  begin
    tmp:=TBitmap.Create;
    try
      tmp.PixelFormat:=Bitmap.PixelFormat;
      TeeSetBitmapSize(tmp,Width,Height);

      tmp.Canvas.CopyRect(TeeRect(0,0,tmp.Width,tmp.Height),
         Bitmap.Canvas,TeeRect(Left,Top,Left+Width-1,Top+Height-1));

      if FSmooth then
         SmoothStretch(tmp,Bitmap)
      else
         Bitmap.Canvas.StretchDraw(TeeRect(0,0,Bitmap.Width-1,Bitmap.Height-1),tmp);
    finally
      tmp.Free;
    end;
  end;

// Do not call inherited;
end;

procedure TCropFilter.CreateEditor(Creator: IFormCreator;
  AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddInteger('Left',TeeMsg_Left,0,10000); // Do not localize
  Creator.AddInteger('Top',TeeMsg_Top,0,10000); // Do not localize
  Creator.AddCheckBox('Smooth',TeeMsg_Smooth); // Do not localize
end;

class function TCropFilter.Description: String;
begin
  result:=TeeMsg_Crop;
end;

{ TInvertFilter }
procedure TInvertFilter.Apply(Bitmap:TBitmap; const R:TRect);
var x,y : Integer;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;
     
  for y:=R.Top to R.Bottom do
    for x:=R.Left to R.Right do
    with Lines[y,x] do
    begin
      Blue:=255-Blue;
      Green:=255-Green;
      Red:=255-Red;
    end;
end;

class function TInvertFilter.Description: String;
begin
  result:=TeeMsg_Invert;
end;

{ TGrayScaleFilter }
procedure TGrayScaleFilter.Apply(Bitmap:TBitmap; const R:TRect);
var x,y :  Integer;
    tmp : Byte;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;
     
  case Method of
    gmSimple: for y:=R.Top to R.Bottom do
                  for x:=R.Left to R.Right do
                  with Lines[y,x] do
                  begin
                    tmp:=(Blue+Green+Red) div 3;
                    Blue:=tmp;
                    Green:=tmp;
                    Red:=tmp;
                  end;
       gmEye: for y:=R.Top to R.Bottom do
                  for x:=R.Left to R.Right do
                  with Lines[y,x] do
                  begin
                    tmp:=Round( (0.30*Red) +
                                (0.59*Green) +
                                (0.11*Blue));

                    Blue:=tmp;
                    Green:=tmp;
                    Red:=tmp;
                  end;
      gmEye2: for y:=R.Top to R.Bottom do
                  for x:=R.Left to R.Right do
                  with Lines[y,x] do
                  begin
                    tmp:=(11*Red+16*Green+5*Blue) div 32;
                    Blue:=tmp;
                    Green:=tmp;
                    Red:=tmp;
                  end;
    end;
end;

procedure TGrayScaleFilter.CreateEditor(Creator: IFormCreator;
  AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddCombo('Method'); // Do not localize
end;

class function TGrayScaleFilter.Description: String;
begin
  result:=TeeMsg_GrayScale;
end;

{ TMosaicFilter }
constructor TMosaicFilter.Create(Collection:TCollection);
begin
  inherited;
  FAmount:=8;
  IOnlyPositive:=True;
end;

procedure TMosaicFilter.Apply(Bitmap:TBitmap; const R:TRect); {$IFDEF CLR}unsafe;{$ENDIF}
var
  tmpAmountX : Integer;
  tmpAmountY : Integer;
  tmpDims    : Single;

  procedure DoMosaic(const tmpX,tmpY:Integer); {$IFDEF CLR}unsafe;{$ENDIF}
  var ar,
      ag,
      ab : Integer;
      xx,
      yy : Integer;
      a    : TRGB;
      Line : PRGBs;
  begin
    ar:=0;
    ag:=0;
    ab:=0;

    for yy:=0 to tmpAmountY do
    begin
      Line:=Lines[tmpY+yy];

      for xx:=0 to tmpAmountX do
      with Line[tmpX+xx] do
      begin
        Inc(ar,Red);
        Inc(ag,Green);
        Inc(ab,Blue);
      end;
    end;

    a.Red:=Round(ar*tmpDims);
    a.Green:=Round(ag*tmpDims);
    a.Blue:=Round(ab*tmpDims);

    for yy:=0 to tmpAmountY do
    begin
      Line:=Lines[tmpY+yy];
      for xx:=0 to tmpAmountX do
          Line[tmpX+xx]:=a;
    end;
  end;

  procedure DoMosaicRow(const tmpY:Integer);
  var tmpX : Integer;
  begin
    tmpX:=R.Left;
    while tmpX<R.Right-Amount do
    begin
      DoMosaic(tmpX,tmpY);
      Inc(tmpX,Amount);
    end;

    // Remainder horizontal mosaic cell
    if tmpX<R.Right then
    begin
      tmpAmountX:=R.Right-tmpX;
      tmpDims:=1.0/(Succ(tmpAmountX)*Succ(tmpAmountY));

      DoMosaic(tmpX,tmpY);

      tmpAmountX:=tmpAmountY;
      tmpDims:=1.0/Sqr(Amount);
    end;
  end;

var tmpY : Integer;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  if Amount>0 then
  begin
    tmpDims:=1.0/Sqr(Amount);
    tmpAmountX:=Amount-1;
    tmpAmountY:=tmpAmountX;

    tmpY:=R.Top;
    while tmpY<R.Bottom-Amount do
    begin
      DoMosaicRow(tmpY);
      Inc(tmpY,Amount);
    end;

    // Remainder vertical mosaic row cells
    if tmpY<R.Bottom then
    begin
      tmpAmountY:=R.Bottom-tmpY-1;
      tmpDims:=1.0/(Succ(tmpAmountX)*Succ(tmpAmountY));
      DoMosaicRow(tmpY);
    end;
  end;
end;

class function TMosaicFilter.Description: String;
begin
  result:=TeeMsg_Mosaic;
end;

{ TFlipFilter }
procedure TFlipFilter.Apply(Bitmap:TBitmap; const R:TRect); {$IFDEF CLR}unsafe;{$ENDIF}
var tmp : TRGB;
    tmpH,
    tmpY,
    x,y : Integer;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  tmpH:=R.Bottom-R.Top;

  for y:=R.Top to R.Top+(tmpH div 2)-1 do
      for x:=R.Left to R.Right do
      begin
        tmp:=Lines[y,x];
        tmpY:=tmpH-y;
        Lines[y,x]:=Lines[tmpY,x];
        Lines[tmpY,x]:=tmp;
      end;
end;

class function TFlipFilter.Description: String;
begin
  result:=TeeMsg_Flip;
end;

{ TReverseFilter }
procedure TReverseFilter.Apply(Bitmap:TBitmap; const R:TRect);
var tmp : TRGB;
    tmpW,
    tmpX,
    x,y : Integer;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;
     
  tmpW:=R.Right-R.Left;

  for x:=R.Left to R.Left+(tmpW div 2)-1 do
      for y:=R.Top to R.Bottom do
      begin
        tmp:=Lines[y,x];
        tmpX:=tmpW-x;
        Lines[y,x]:=Lines[y,tmpX];
        Lines[y,tmpX]:=tmp;
      end;
end;

class function TReverseFilter.Description: String;
begin
  result:=TeeMsg_Reverse;
end;

{ TAmountFilter }
Constructor TAmountFilter.Create(Collection:TCollection);
begin
  inherited;
  FPercent:=True;
  FAmount:=5; // %
end;

function TAmountFilter.ScrollMin:Integer;
begin
  if FPercent then
     if IOnlyPositive then result:=0 else result:=-100
  else
     if IOnlyPositive then result:=0 else result:=-255;
end;

function TAmountFilter.ScrollMax:Integer;
begin
  if FPercent then result:=100
              else result:=255;
end;

procedure TAmountFilter.ResetScroll(Sender:TObject);
begin
  FScrollBar.Min:=ScrollMin;
  FScrollBar.Max:=ScrollMax;
end;

procedure TAmountFilter.CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent);
begin
  inherited;
  FScrollBar:=Creator.AddScroll('Amount',ScrollMin,ScrollMax); // Do not localize
  Creator.AddCheckBox('Percent',TeeMsg_Percent,ResetScroll); // Do not localize
end;

{ TBrightnessFilter }
procedure TBrightnessFilter.Apply(Bitmap:TBitmap; const R: TRect);
var x,y,l :  Integer;
    IPercent : Single;
begin
  if Amount=0 then
     Exit;

  inherited;

  if Length(Lines)=0 then
     Exit;

  if Percent then
  begin
    IPercent:=FAmount*0.01;

    for y:=R.Top to R.Bottom do
        for x:=R.Left to R.Right do
        with Lines[y,x] do
        begin
          l:=Red+Round(255*IPercent);
          if l<0 then Red:=0 else if l>255 then Red:=255 else Red:=l;

          l:=Green+Round(255*IPercent);
          if l<0 then Green:=0 else if l>255 then Green:=255 else Green:=l;

          l:=Blue+Round(255*IPercent);
          if l<0 then Blue:=0 else if l>255 then Blue:=255 else Blue:=l;
        end;
  end
  else
  for y:=R.Top to R.Bottom do
      for x:=R.Left to R.Right do
      with Lines[y,x] do
      begin
        l:=Red+Amount;
        if l<0 then Red:=0 else if l>255 then Red:=255 else Red:=l;

        l:=Green+Amount;
        if l<0 then Green:=0 else if l>255 then Green:=255 else Green:=l;

        l:=Blue+Amount;
        if l<0 then Blue:=0 else if l>255 then Blue:=255 else Blue:=l;
      end;
end;

class function TBrightnessFilter.Description: String;
begin
  result:=TeeMsg_Brightness;
end;

procedure ColorToHLS(Color: TColor; out Hue, Luminance, Saturation: Word);
var tmp : TRGB;
begin
  Color:=ColorToRGB(Color);
  tmp.Red:=GetRValue(Color);
  tmp.Green:=GetGValue(Color);
  tmp.Blue:=GetBValue(Color);
  RGBToHLS(tmp,Hue,Luminance,Saturation);
end;

type
  Float=Single;

const
  // HLSMAX BEST IF DIVISIBLE BY 6.  RGBMAX, HLSMAX must each fit in a byte.
  HLSMAX = 240;  // H,L, and S vary over 0-HLSMAX
  RGBMAX = 255;  // R,G, and B vary over 0-RGBMAX

  RGBMAX2 = 2.0*RGBMAX;
  InvRGBMAX2 = 1.0/RGBMAX2;

  HLSMAXDiv2=HLSMAX/2;
  HLSMAXDiv3=HLSMAX/3;
  HLSMAXDiv6=HLSMAX/6;
  HLSMAXDiv12=HLSMAX/12;
  HLSMAX2=HLSMAX*2;
  HLSMAX3=HLSMAX*3;
  HLSMAX2Div3=HLSMAX2/3;

  { Hue is undefined if Saturation is 0 (grey-scale)
    This value determines where the Hue scrollbar is
    initially set for achromatic colors }
  HLSUndefined = 160; // HLSMAX2Div3;

procedure RGBToHLS(const Color: TRGB; out Hue, Luminance, Saturation: Word);
var
  H, L, S: Float;
  R, G, B: Word;
  dif : Integer;
  sum, cMax, cMin: Word;
  Rdelta, Gdelta, Bdelta: Extended; { intermediate value: % of spread from max }
begin
  R:=Color.Red;
  G:=Color.Green;
  B:=Color.Blue;

  { calculate lightness }
  if R>G then
     if R>B then cMax:=R else cMax:=B
  else
     if G>B then cMax:=G else cMax:=B;

  if R<G then
     if R<B then cMin:=R else cMin:=B
  else
     if G<B then cMin:=G else cMin:=B;

  sum:=(cMax + cMin);

  L := ( (sum * HLSMAX) + RGBMAX ) / ( 2 * RGBMAX);

  if cMax = cMin then  { r=g=b --> achromatic case }
  begin                { saturation }
    Hue := Round(HLSUndefined);
//    pwHue := 160;      { MS ColoroHLS always defaults to 160 in this case }
    Luminance := Round(L);
    Saturation := 0;
  end
  else                 { chromatic case }
  begin
    dif:=cMax-cMin;

    { saturation }
    if L <= HLSMAXDiv2 then
       S := ( (dif*HLSMAX) + (sum*0.5) ) / sum
    else
       S := ( (dif*HLSMAX) + ( RGBMAX-(sum*0.5) )) / (2*RGBMAX-sum);

    { hue }
    Rdelta := ( ((cMax-R)*HLSMAXDiv6) + (dif*0.5) ) / dif;
    Gdelta := ( ((cMax-G)*HLSMAXDiv6) + (dif*0.5) ) / dif;
    Bdelta := ( ((cMax-B)*HLSMAXDiv6) + (dif*0.5) ) / dif;

    if R = cMax then
       H := Bdelta - Gdelta
    else
    if G = cMax then
       H := HLSMAX3 + Rdelta - Bdelta
    else // B == cMax
       H := HLSUndefined + Gdelta - Rdelta;

    if H < 0 then H := H + HLSMAX
    else
    if H > HLSMAX then H := H - HLSMAX;

    Hue := Round(H);
    Luminance := Round(L);
    Saturation := Round(S);
  end;
end;

function HLSToColor(Hue, Luminance, Saturation: Word):TColor;
var tmp : TRGB;
begin
  HLSToRGB(Hue,Luminance,Saturation,tmp);
  result:=RGB(tmp.Red,tmp.Green,tmp.Blue);
end;

procedure HLSToRGB(Hue, Luminance, Saturation: Word; out rgb: TRGB);

  function HueToRGB(const Lum, Sat:Float; Hue: Float): Integer;
  begin
    { range check: note values passed add/subtract thirds of range }
    if hue < 0 then hue:=hue+HLSMAX;
    if hue > HLSMAX then hue:=hue-HLSMAX;

    { return r,g, or b value from this tridrant }
    if hue < HLSMAXDiv6 then
        Result := Round( Lum + (((Sat-Lum)*hue+HLSMAXDiv12)/HLSMAXDiv6))
    else
    if hue < HLSMAXDiv2 then
        Result := Round( Sat)
    else
    if hue < HLSMAX2Div3 then
        Result := Round( Lum + (((Sat-Lum)*(HLSMAX2Div3-hue)+HLSMAXDiv12)/HLSMAXDiv6) )
    else
        Result := Round( Lum );
  end;

  function RoundColor(const Value: Integer): Integer;
  begin
    if Value > 255 then Result := 255 else Result := Round(Value);
  end;

var
  Magic1, Magic2: Float;       { calculated magic numbers (really!) }

  function RoundColor2(const Hue: Float): Integer;
  begin
    result:=RoundColor(Round((HueToRGB(Magic1,Magic2,Hue)*RGBMAX + HLSMAXDiv2)/HLSMAX));
  end;

begin
  if Saturation = 0 then
  with rgb do
  begin            { achromatic case }
    Red := RoundColor(Round((Luminance * RGBMAX)/HLSMAX) );
    Green:=Red;
    Blue:=Green;
    if Hue <> HLSUndefined then ;{ ERROR }
  end
  else
  begin            { chromatic case }
    { set up magic numbers }
    if Luminance <= HLSMAXDiv2 then
       Magic2 := (Luminance * (HLSMAX + Saturation) + HLSMAXDiv2) / HLSMAX
    else
       Magic2 := Luminance + Saturation - ((Luminance * Saturation) + HLSMAXDiv2) / HLSMAX;

    Magic1 := 2 * Luminance - Magic2;

    { get RGB, change units from HLSMAX to RGBMAX }
    rgb.Red:=RoundColor2(Hue+HLSMAXDiv3);
    rgb.Green:=RoundColor2(Hue);
    rgb.Blue:=RoundColor2(Hue-HLSMAXDiv3);
  end;
end;

{ TColorFilter }

procedure TColorFilter.Apply(Bitmap:TBitmap; const R: TRect); {$IFDEF CLR}unsafe;{$ENDIF}
var x,y    : Integer;
    tmpInt : Integer;
    Line   : PRGBs;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  if (Red<>0) or (Green<>0) or (Blue<>0) then
  for y:=R.Top to R.Bottom do
  begin
    Line:=Lines[y];

    for x:=R.Left to R.Right do
    with Line[x] do
    begin
      if Self.FRed<>0 then
      begin
        tmpInt:=Red+Self.FRed;
        if tmpInt<0 then Red:=0 else
        if tmpInt>255 then Red:=255 else
                           Red:=tmpInt;
      end;

      if Self.FGreen<>0 then
      begin
        tmpInt:=Green+Self.FGreen;
        if tmpInt<0 then Green:=0 else
        if tmpInt>255 then Green:=255 else
                           Green:=tmpInt;
      end;

      if Self.FBlue<>0 then
      begin
        tmpInt:=Blue+Self.FBlue;
        if tmpInt<0 then Blue:=0 else
        if tmpInt>255 then Blue:=255 else
                           Blue:=tmpInt;
      end;
    end;
  end;
end;

procedure TColorFilter.CreateEditor(Creator: IFormCreator;
  AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddScroll('Red',-255,255); // Do not localize
  Creator.AddScroll('Green',-255,255); // Do not localize
  Creator.AddScroll('Blue',-255,255); // Do not localize
end;

class function TColorFilter.Description: String;
begin
  result:=TeeMsg_Color;
end;

{ THueLumSatFilter }

procedure THueLumSatFilter.Apply(Bitmap:TBitmap; const R: TRect); {$IFDEF CLR}unsafe;{$ENDIF}
var x,y    : Integer;
    tmpInt : Integer;
    tmpHue : Word;
    tmpLum : Word;
    tmpSat : Word;
    Line   : PRGBs;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  if (FHue<>0) or (FLum<>0) or (FSat<>0) then
  for y:=R.Top to R.Bottom do
  begin
    Line:=Lines[y];

    for x:=R.Left to R.Right do
    begin
      RGBToHLS(Line[x],tmpHue,tmpLum,tmpSat);

      if Self.FHue<>0 then
      begin
        tmpInt:=tmpHue+Self.FHue;
        if tmpInt<0 then tmpHue:=0 else
        if tmpInt>255 then tmpHue:=255 else
                           tmpHue:=tmpInt;
      end;

      if Self.FLum<>0 then
      begin
        tmpInt:=tmpLum+Self.FLum;
        if tmpInt<0 then tmpLum:=0 else
        if tmpInt>255 then tmpLum:=255 else
                           tmpLum:=tmpInt;
      end;

      if Self.FSat<>0 then
      begin
        tmpInt:=tmpSat+Self.FSat;
        if tmpInt<0 then tmpSat:=0 else
        if tmpInt>255 then tmpSat:=255 else
                           tmpSat:=tmpInt;
      end;

      HLSToRGB(tmpHue,tmpLum,tmpSat,Line[x]);
    end;
  end;
end;

procedure THueLumSatFilter.CreateEditor(Creator: IFormCreator;
  AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddScroll('Hue',-255,255); // Do not localize
  Creator.AddScroll('Luminance',-255,255); // Do not localize
  Creator.AddScroll('Saturation',-255,255); // Do not localize
end;

class function THueLumSatFilter.Description: String;
begin
  result:=TeeMsg_HueLumSat;
end;

{ TSharpenFilter }

procedure TSharpenFilter.Apply(Bitmap:TBitmap; const R: TRect);
const Center=2.0;
      Pix=-((Center-1)/8.0);
begin
  Weights[-1,-1]:=Pix;  Weights[-1,0]:=Pix;    Weights[-1,1]:=Pix;
  Weights[ 0,-1]:=Pix;  Weights[ 0,0]:=Center; Weights[ 0,1]:=Pix;
  Weights[ 1,-1]:=Pix;  Weights[ 1,0]:=Pix;    Weights[ 1,1]:=Pix;

  InvTotalWeight:=1.0/16.0;

  inherited;
end;

class function TSharpenFilter.Description: String;
begin
  result:=TeeMsg_Sharpen;
end;

{ TGammaCorrectionFilter }
Constructor TGammaCorrectionFilter.Create(Collection:TCollection);
begin
  inherited;
  FAmount:=70;
  IOnlyPositive:=True;
end;

procedure TGammaCorrectionFilter.Apply(Bitmap:TBitmap; const R: TRect);
var t,
    x,y    : Integer;
    IGamma : Array[0..255] of Byte;
    tmp    : Single;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  tmp:=Max(0.001,Abs(Amount)*0.01);

  IGamma[0]:=0;
  for t:=1 to 255 do
      IGamma[t]:=Round(Exp(Ln(t/255.0)/tmp)*255.0);

  for y:=R.Top to R.Bottom do
    for x:=R.Left to R.Right do
    with Lines[y,x] do
    begin
      Red:=IGamma[Red];
      Green:=IGamma[Green];
      Blue:=IGamma[Blue];
    end;
end;

class function TGammaCorrectionFilter.Description: String;
begin
  result:=TeeMsg_GammaCorrection;
end;

{ TEmbossFilter }

procedure TEmbossFilter.Apply(Bitmap:TBitmap; const R: TRect);
begin
  Weights[-1,-1]:= 0;  Weights[-1,0]:=-1;    Weights[-1,1]:=0;
  Weights[ 0,-1]:=-1;  Weights[ 0,0]:=1;     Weights[ 0,1]:=1;
  Weights[ 1,-1]:= 0;  Weights[ 1,0]:=-1;    Weights[ 1,1]:=0;

  InvTotalWeight:=1.0/1.0;

  inherited;
end;

class function TEmbossFilter.Description: String;
begin
  result:=TeeMsg_Emboss;
end;

{ TContrastFilter }

procedure TContrastFilter.Apply(Bitmap:TBitmap; const R: TRect);
var x,y,l :  Integer;
    IPercent : Single;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  if Percent then
     IPercent:=FAmount*0.01
  else
     IPercent:=1;

  for y:=R.Top to R.Bottom do
      for x:=R.Left to R.Right do
      with Lines[y,x] do
      begin
        if Percent then l:=Red+(Round(Red*IPercent)*(Red-128) div 256)
                   else l:=Red+(Amount*(Red-128) div 256);

        if l<0 then Red:=0 else if l>255 then Red:=255 else Red:=l;

        if Percent then l:=Green+(Round(Green*IPercent)*(Green-128) div 256)
                   else l:=Green+(Amount*(Green-128) div 256);

        if l<0 then Green:=0 else if l>255 then Green:=255 else Green:=l;

        if Percent then l:=Blue+(Round(Blue*IPercent)*(Blue-128) div 256)
                   else l:=Blue+(Amount*(Blue-128) div 256);

        if l<0 then Blue:=0 else if l>255 then Blue:=255 else Blue:=l;
      end;
end;

class function TContrastFilter.Description: String;
begin
  result:=TeeMsg_Contrast;
end;

{ TSoftenFilter }

procedure TSoftenFilter.Apply(Bitmap:TBitmap; const R: TRect);
begin
  Weights[-1,-1]:=0;  Weights[-1,0]:=0;    Weights[-1,1]:=0;
  Weights[ 0,-1]:=0;  Weights[ 0,0]:=1;    Weights[ 0,1]:=1;
  Weights[ 1,-1]:=0;  Weights[ 1,0]:=1;    Weights[ 1,1]:=1;

  InvTotalWeight:=1.0/4.0;

  inherited;
end;

class function TSoftenFilter.Description: String;
begin
  result:=TeeMsg_AntiAlias;
end;

{ TImageFiltered }

Constructor TImageFiltered.Create(AOwner: TComponent);
begin
  inherited;
  FFilters:=TFilterItems.Create(Self,TTeeFilter);
end;

Destructor TImageFiltered.Destroy;
begin
  FFilters.Free;
  inherited;
end;

function TImageFiltered.Filtered:TBitmap;
var tmpDest : TBitmap;
    tmpR    : TRect;
    tmpW    : Integer;
    tmpH    : Integer;
begin
  result:=TBitmap.Create;
  result.Assign(Picture.Graphic);

  tmpR:=DestRect;
  tmpW:=tmpR.Right-tmpR.Left;
  tmpH:=tmpR.Bottom-tmpR.Top;

  if (tmpW<>result.Width) or (tmpH<>result.Height) then
  begin
    tmpDest:=SmoothBitmap(result,tmpW,tmpH);
    result.Free;
    result:=tmpDest;
  end;

  FFilters.ApplyTo(result);
end;

procedure TImageFiltered.SetFilters(const Value: TFilterItems);
begin
  FFilters.Assign(Value);
end;

procedure TImageFiltered.Paint;
var tmpCanvas : TCanvas;
    tmp       : TGraphic;
begin
  tmp:=Filtered;
  try
    tmpCanvas:=TControlCanvas.Create;
    try
      TControlCanvas(tmpCanvas).Control:=Self;
      tmpCanvas.Draw(0,0,tmp);

      if csDesigning in ComponentState then
      with tmpCanvas do
      begin
        Pen.Style:=psDash;
        Brush.Style:=bsClear;

        {$IFDEF CLX}
        Start;
        QPainter_setBackgroundMode(Handle,BGMode_TransparentMode);
        Stop;
        {$ELSE}
        SetBkMode(Handle,Windows.TRANSPARENT);
        {$ENDIF}

        with ClientRect do
             Rectangle(Left,Top,Right,Bottom);
      end;
    finally
      tmpCanvas.Free;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TImageFiltered.ReadFilters(Reader: TReader);
begin
  TTeePicture.ReadFilters(Reader,Filters);
end;

procedure TImageFiltered.WriteFilters(Writer: TWriter);
begin
  TTeePicture.WriteFilters(Writer,Filters);
end;

function TImageFiltered.FiltersStored:Boolean;
begin
  result:=Assigned(FFilters) and (FFilters.Count>0);
end;

procedure TImageFiltered.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('FilterItems',ReadFilters,WriteFilters,FiltersStored);  // Do not localize
end;

{ TRotateFilter }

Constructor TRotateFilter.Create(Collection:TCollection);
begin
  inherited;
  FBackColor:=clWhite;
  FAutoSize:=True;
end;

procedure TRotateFilter.Apply(Bitmap: TBitmap; const R: TRect); {$IFDEF CLR}unsafe;{$ENDIF}
const
  TeePiStep:Single=Pi/180.0;

var tmp : TBitmap;
    x,
    y,
    xc,
    yc,
    xxc,
    yyc,
    tmpY,
    tmpX,
    h,
    w   : Integer;

    f2 : TTeeFilter;

    f2Lines : PRGBs;

    xx,
    yy : Integer;

    tmpSin,
    tmpCos,
    tmpYSin,
    tmpYCos  : Single;

    Sin,
    Cos : Extended;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  while Angle>360 do
        FAngle:=Angle-360;

  if Angle=180 then
  begin
    TFlipFilter.ApplyTo(Bitmap);
    TReverseFilter.ApplyTo(Bitmap);
  end
  else
  if Angle<>0 then
  begin
    tmp:=TBitmap.Create;
    try
      h:=Bitmap.Height;
      w:=Bitmap.Width;

      if (Angle=90) or (Angle=270) then
         TeeSetBitmapSize(tmp,h,w)
      else
      begin
        SinCos((360-Angle)*TeePiStep,Sin,Cos);

        if AutoSize then
        begin
          if Sin*Cos>0 then
             TeeSetBitmapSize(tmp,Abs(Round(w*Cos+h*Sin)),
                                  Abs(Round(w*Sin+h*Cos)))
          else
             TeeSetBitmapSize(tmp,Abs(Round(w*Cos-h*Sin)),
                                  Abs(Round(w*Sin-h*Cos)));
        end
        else
          TeeSetBitmapSize(tmp,w,h);
      end;

      if (w>1) and (h>1) then
      begin
        if BackColor=clNone then
           tmp.Transparent:=True
        else
        if BackColor<>clWhite then
        with tmp.Canvas do
        begin
          Brush.Style:=bsSolid;
          Brush.Color:=FBackColor;
          FillRect(TeeRect(0,0,tmp.Width,tmp.Height));
        end;

        f2:=TTeeFilter.Create(nil);
        try
          f2.Apply(tmp);

          if Angle=90 then
          begin
            for y:=0 to h-1 do
                for x:=0 to w-1 do
                    f2.Lines[x,h-y-1]:=Lines[y,x];
          end
          else
          if Angle=270 then
          begin
            for y:=0 to h-1 do
                for x:=0 to w-1 do
                    f2.Lines[w-x-1,y]:=Lines[y,x];
          end
          else
          begin
            xxc:=tmp.Width div 2;
            yyc:=tmp.Height div 2;

            xc:=w div 2;
            yc:=h div 2;

            tmpSin:=Sin;
            tmpCos:=Cos;

            tmpY:=-yyc-1;

            for y:=0 to tmp.Height-1 do
            begin
              Inc(tmpY);
              tmpYSin:=(tmpY*tmpSin)-xc;
              tmpYCos:=(tmpY*tmpCos)+yc;

              f2Lines:=f2.Lines[y];

              tmpX:=-xxc-1;

              for x:=0 to tmp.Width-1 do
              begin
                Inc(tmpX);

                xx:=Round(tmpX*tmpCos-tmpYSin);

                if (xx>=0) and (xx<w) then
                begin
                  yy:=Round(tmpX*tmpSin+tmpYCos);

                  if (yy>=0) and (yy<h) then
                     f2Lines[x]:=Lines[yy,xx];
                end;
              end;
            end;
          end;

          Bitmap.FreeImage;
          Bitmap.Assign(tmp);
        finally
          f2.Free;
        end;
      end;
    finally
      tmp.Free;
    end;
  end;
end;

class function TRotateFilter.Description: String;
begin
  result:=TeeMsg_Rotate;
end;

procedure TRotateFilter.SetAngle(const Value: Double);
begin
  if FAngle<>Value then
  begin
    FAngle:=Value;
    // Repaint;
  end;
end;

procedure TRotateFilter.CreateEditor(Creator:IFormCreator; AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddScroll('Angle',0,360); // Do not localize
  Creator.AddColor('BackColor',TeeMsg_Back); // Do not localize
  Creator.AddCheckBox('AutoSize',TeeMsg_Autosize); // Do not localize
end;

{ TMirrorFilter }

Constructor TMirrorFilter.Create(Collection: TCollection);
begin
  inherited;
  AllowRegion:=False;
end;

procedure TMirrorFilter.Apply(Bitmap: TBitmap; const R: TRect);
var tmp : TBitmap;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  tmp:=TBitmap.Create;
  try
    if (Direction=mdDown) or (Direction=mdUp) then
    begin
      TeeSetBitmapSize(tmp,Bitmap.Width,Bitmap.Height*2);

      if Direction=mdDown then
         tmp.Canvas.Draw(0,0,Bitmap)
      else
         tmp.Canvas.Draw(0,Bitmap.Height,Bitmap);

      TFlipFilter.ApplyTo(Bitmap);

      if Direction=mdDown then
         tmp.Canvas.Draw(0,Bitmap.Height,Bitmap)
      else
         tmp.Canvas.Draw(0,0,Bitmap);

      Bitmap.Height:=Bitmap.Height*2;
    end
    else
    begin
      TeeSetBitmapSize(tmp,Bitmap.Width*2,Bitmap.Height);

      if Direction=mdRight then
         tmp.Canvas.Draw(0,0,Bitmap)
      else
         tmp.Canvas.Draw(Bitmap.Width,0,Bitmap);

      TReverseFilter.ApplyTo(Bitmap);

      if Direction=mdRight then
         tmp.Canvas.Draw(Bitmap.Width,0,Bitmap)
      else
         tmp.Canvas.Draw(0,0,Bitmap);

      Bitmap.Width:=Bitmap.Width*2;
    end;

    Bitmap.Canvas.Draw(0,0,tmp);
  finally
    tmp.Free;
  end;
end;

procedure TMirrorFilter.CreateEditor(Creator: IFormCreator;
  AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddCombo('Direction'); // Do not localize
end;

class function TMirrorFilter.Description: String;
begin
  result:=TeeMsg_Mirror;
end;

{ TTileFilter }

Constructor TTileFilter.Create(Collection: TCollection);
begin
  inherited;
  FNumCols:=3;
  FNumRows:=3;
end;

procedure TTileFilter.Apply(Bitmap: TBitmap; const R: TRect);
var tmpCol,
    tmpRow,
    tmpW,
    tmpH : Integer;
    tmp  : TBitmap;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  if FNumCols<1 then FNumCols:=1;
  if FNumRows<1 then FNumRows:=1;

  tmpW:=(R.Right-R.Left) div FNumCols;
  tmpH:=(R.Bottom-R.Top) div FNumRows;

  if (tmpW>0) and (tmpH>0) then
  begin
    tmp:=SmoothBitmap(Bitmap,tmpW,tmpH);
    try
      for tmpCol:=0 to FNumCols-1 do
          for tmpRow:=0 to FNumRows-1 do
              Bitmap.Canvas.Draw(tmpCol*tmpW,tmpRow*tmpH,tmp);
    finally
      tmp.Free;
    end;
  end;
end;

procedure TTileFilter.CreateEditor(Creator: IFormCreator;
  AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddInteger('NumCols',TeeMsg_Columns,1,1000); // Do not localize
  Creator.AddInteger('NumRows',TeeMsg_Rows,1,1000); // Do not localize
end;

class function TTileFilter.Description: String;
begin
  result:=TeeMsg_Tile;
end;

{ TBevelFilter }

Constructor TBevelFilter.Create(Collection: TCollection);
begin
  inherited;
  FBright:=64;
  FSize:=15;
end;

procedure TBevelFilter.Apply(Bitmap: TBitmap; const R: TRect);
var t,
    x,y,
    h2,w2,
    x1,x2,
    y1,y2 : Integer;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  x1:=R.Left;
  x2:=R.Right;
  y1:=R.Top;
  y2:=R.Bottom;

  w2:=(R.Right-R.Left) div 2;
  h2:=(R.Bottom-R.Top) div 2;

  for t:=0 to FSize-1 do
  begin
    if t<h2 then
    for x:=R.Left+t to R.Right-t do
    begin
      with Lines[y1,x] do
      begin
        if Red+Bright>255 then Red:=255
                          else Inc(Red,Bright);
        if Green+Bright>255 then Green:=255
                            else Inc(Green,Bright);
        if Blue+Bright>255 then Blue:=255
                           else Inc(Blue,Bright);
      end;

      with Lines[y2,x] do
      begin
        if Red-Bright<0 then Red:=0
                        else Dec(Red,Bright);
        if Green-Bright<0 then Green:=0
                          else Dec(Green,Bright);
        if Blue-Bright<0 then Blue:=0
                         else Dec(Blue,Bright);
      end;

    end;

    Inc(y1);
    Dec(y2);

    if t<w2 then
    for y:=R.Top+t+1 to R.Bottom-t do
    begin
      with Lines[y,x1] do
      begin
        if Red+Bright>255 then Red:=255
                          else Inc(Red,Bright);
        if Green+Bright>255 then Green:=255
                            else Inc(Green,Bright);
        if Blue+Bright>255 then Blue:=255
                           else Inc(Blue,Bright);
      end;

      with Lines[y,x2] do
      begin
        if Red-Bright<0 then Red:=0
                        else Dec(Red,Bright);
        if Green-Bright<0 then Green:=0
                          else Dec(Green,Bright);
        if Blue-Bright<0 then Blue:=0
                         else Dec(Blue,Bright);
      end;
    end;

    Inc(x1);
    Dec(x2);
  end;
end;

procedure TBevelFilter.CreateEditor(Creator: IFormCreator;
  AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddScroll('Bright',1,255); // Do not localize
  Creator.AddScroll('Size',1,1000); // Do not localize
end;

class function TBevelFilter.Description: String;
begin
  result:=TeeMsg_Bevel;
end;

{ TZoomFilter }

Constructor TZoomFilter.Create(Collection: TCollection);
begin
  inherited;
  FPercent:=10;
end;

procedure TZoomFilter.Apply(Bitmap: TBitmap; const R: TRect);
var w,h,
    wp,hp : Integer;

  procedure DoCrop(ALeft,ATop:Integer; ABitmap:TBitmap);
  begin
    with TCropFilter.Create(nil) do
    try
      Left:=ALeft+wp;
      Top:=ATop+hp;
      Width:=Max(1,w-2*wp);
      Height:=Max(1,h-2*hp);
      Smooth:=Self.Smooth;
      Apply(ABitmap,R);
    finally
      Free;
    end;
  end;

var tmp : TBitmap;
begin
  w:=R.Right-R.Left+1;
  h:=R.Bottom-R.Top+1;
  wp:=Round(FPercent*w*0.005);
  hp:=Round(FPercent*h*0.005);

  if (Bitmap.Width=w) and (Bitmap.Height=h) then
     DoCrop(R.Left,R.Top,Bitmap)
  else
  begin
    tmp:=TBitmap.Create;
    try
      TeeSetBitmapSize(tmp,w,h);
      tmp.Canvas.CopyRect(TeeRect(0,0,w,h),Bitmap.Canvas,R);

      DoCrop(0,0,tmp);

      Bitmap.Canvas.Draw(R.Left,R.Top,tmp);
    finally
      tmp.Free;
    end;
  end;
end;

procedure TZoomFilter.CreateEditor(Creator: IFormCreator;
  AChanged: TNotifyEvent);
begin
  inherited;
  Creator.AddScroll('Percent',0,100); // Do not localize
  Creator.AddCheckBox('Smooth',TeeMsg_Smooth); // Do not localize
end;

class function TZoomFilter.Description: String;
begin
  result:=TeeMsg_Zoom;
end;

procedure RotateGradient(Gradient:TCustomTeeGradient; ABitmap:TBitmap);
begin
  with TRotateFilter.Create(nil) do
  try
    Angle:=Gradient.Angle;
    Apply(ABitmap);
  finally
    Free;
  end;
end;

// This procedure will convert all pixels in ABitmap to levels of gray
Procedure TeeGrayScale(ABitmap:TBitmap; Inverted:Boolean; AMethod:Integer);
var tmp : TGrayScaleFilter;
begin
  tmp:=TGrayScaleFilter.Create(nil);
  try
    if AMethod<>0 then tmp.Method:=gmEye;
    tmp.Apply(ABitmap);
  finally
    tmp.Free;
  end;

  if Inverted then
     TInvertFilter.ApplyTo(ABitmap);
end;

initialization
  TeeRegisterFilters([ TInvertFilter,
                       TGrayScaleFilter,
                       TMosaicFilter,
                       TFlipFilter,
                       TReverseFilter,
                       TBrightnessFilter,
                       TContrastFilter,
                       TColorFilter,
                       THueLumSatFilter,
                       TBlurFilter,
                       TSharpenFilter,
                       TGammaCorrectionFilter,
                       TEmbossFilter,
                       TSoftenFilter,
                       TCropFilter,
                       TResizeFilter,
                       TRotateFilter,
                       TMirrorFilter,
                       TTileFilter,
                       TBevelFilter,
                       TZoomFilter ]);

  TeeGradientRotate:=RotateGradient;
finalization
  TeeGradientRotate:=nil;
  FreeAndNil(FilterClasses);
end.

