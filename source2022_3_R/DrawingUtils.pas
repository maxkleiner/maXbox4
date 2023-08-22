unit DrawingUtils;

interface

uses Windows, SysUtils, Classes, Graphics, StringUtils;

type
  TDBDraw = record
    DisplayDC, MemDC: HDC;
    MemBitmap, OldBitmap: HBITMAP;
    OldFont: HFONT;
    OldPen: HPEN;
  end;

  TPieceFormatData = record
    Position: TMaskMatchInfo;
    Color: TColor;
  end;
  TFormatData = array of TPieceFormatData;

  TDrawFormattedTextSettings = record
    Text: WideString;
    FormatData: TFormatData;
    Canvas: TCanvas;
    WrapText: Boolean;
    DestPos: TPoint;
    MaxWidth: Word;
    CharSpacing: Word;
  end;

  TWrapTextSettings = record
    DC: HDC;
    Str: WideString;
    Delimiter: WideString;
    MaxWidth: Word;     // pixels.
    LeftMargin: Word;
    CharSpacing: Word; // vertical spacing in pixels between the two chars.

    LastChar: TSize;   // is set by the function.
  end;

function TextSize(const DC: HDC; const Str: WideString): TSize;
function TextWidth(const DC: HDC; const Str: WideString): Integer;
function TextHeight(const DC: HDC; const Str: WideString): Integer;

function GetLineHeightOf(const Font: HFONT): Word;

function TextWidthEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): Integer;
function TextHeightEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): Integer;
function TextSizeEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): TSize; overload;
function TextWithBreaksSize(Settings: TWrapTextSettings): TSize; overload;

function DoubleBufferedDraw(const DisplaySurface: HDC; const BufferSize: TPoint): TDBDraw; overload;
function DoubleBufferedDraw(const Canvas: TCanvas; const BufferSize: TPoint): TDBDraw; overload;
procedure DrawFormattedText(const Settings: TDrawFormattedTextSettings);

function GetLastCharPos(const DC: HDC; const Str: WideString;
  const MaxWidth: Word; const CharSpacing: Word = 0): TSize;
// MaxWidth is in pixels.
function WrapNonMonospacedText(const DC: HDC; const Str: WideString;
  const Delimiter: WideString; const MaxWidth: Word; const CharSpacing: Word = 0): WideString; overload;
function WrapNonMonospacedText(var Settings: TWrapTextSettings): WideString; overload;

implementation

uses MMSystem, Math;

function RemoveNonWordChars(const Str: WideString; DoNotRemove: WideString = ''): WideString;
var
  I: Word;
begin
  Result := Str;
  if Length(Result) <> 0 then
    for I := Length(Result) downto 1 do
      if not IsDelimiter(DoNotRemove, Result, I) and
         (((Word(Result[I]) <> Word(' ')) and (Word(Result[I]) <= Word('/'))) or
          ((Word(Result[I]) >= Word(':')) and (Word(Result[I]) <= Word('?'))) or
          ((Word(Result[I]) >= Word('[')) and (Word(Result[I]) <= Word('`'))) or
          ((Word(Result[I]) >= Word('{')) and (Word(Result[I]) <= Word('}')))) then
        Delete(Result, I, 1)
end;

function DoubleBufferedDraw(const DisplaySurface: HDC; const BufferSize: TPoint): TDBDraw;
begin
  ZeroMemory(@Result, SizeOf(Result));
  with Result do
  begin
    DisplayDC := DisplaySurface;
    MemBitmap := CreateCompatibleBitmap(DisplayDC, BufferSize.X, BufferSize.Y);
    MemDC := CreateCompatibleDC(DisplayDC);
    OldBitmap := SelectObject(MemDC, MemBitmap)
  end
end;

function DoubleBufferedDraw(const Canvas: TCanvas; const BufferSize: TPoint): TDBDraw;
begin
  Result := DoubleBufferedDraw(Canvas.Handle, BufferSize);

  with Result do
  begin
    OldFont := SelectObject(MemDC, Canvas.Font.Handle);
    OldPen := SelectObject(MemDC, Canvas.Pen.Handle);
    SetBkColor(MemDC, ColorToRGB(Canvas.Brush.Color))
  end
end;

procedure FinishDrawing(const Struct: TDBDraw; const DisplayPos, BufferPos: TPoint);
begin
  with Struct do
  begin
    BitBlt(DisplayDC, DisplayPos.X, DisplayPos.Y, BufferPos.X, BufferPos.Y, MemDC, 0, 0, SRCCOPY);

    if OldPen <> 0 then
      SelectObject(MemDC, OldPen);
    if OldFont <> 0 then
      SelectObject(MemDC, OldFont);

    SelectObject(MemDC, OldBitmap);
    DeleteDC(MemDC);
    DeleteObject(MemBitmap)
  end
end;

function TextSize(const DC: HDC; const Str: WideString): TSize;
var
  Rect: TRect;
begin
  DrawTextW(DC, PWideChar(Str), Length(Str), Rect, DT_CALCRECT);
  Result.cx := Rect.Right - Rect.Left;
  Result.cy := Rect.Bottom - Rect.Top;
end;

function TextWidth(const DC: HDC; const Str: WideString): Integer;
begin
  Result := TextSize(DC, Str).cx
end;

function TextHeight(const DC: HDC; const Str: WideString): Integer;
begin
  Result := TextSize(DC, Str).cy
end;

function TextSizeEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): TSize;
var
  Settings: TWrapTextSettings;
begin
  Settings.Str := Str;
  Settings.DC := DC;
  Settings.Delimiter := #10;
  Settings.LeftMargin := 0;
  Settings.CharSpacing := CharSpacing;
  Result := TextWithBreaksSize(Settings);
end;

function TextWidthEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): Integer;
begin
  Result := TextSizeEx(DC, Str, CharSpacing).cx
end;

function TextHeightEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): Integer;
begin
  Result := TextSizeEx(DC, Str, CharSpacing).cy
end;

function TextWithBreaksSize(Settings: TWrapTextSettings): TSize;
var
  Str: WideString;
  I, CurrentX: Word;
  Extent: TSize;
begin
  { Used fields of Settings are:
    DC, Str, LeftMargin, Delimiter, CharSpacing. }

  Str := Settings.Str;

  Result.cx := 0;
  Result.cy := TextHeight(Settings.DC, 'w');
  CurrentX := Settings.LeftMargin;

  for I := 1 to Length(Str) do
  begin
    GetTextExtentPoint32W(Settings.DC, @Str[I], 1, Extent);
    if Str[I] = Settings.Delimiter then
    begin
      Result.cx := Max(Result.cx, CurrentX);
      CurrentX := Settings.LeftMargin;;
      Inc(Result.cy, Extent.cy);
    end
      else
        Inc(Result.cx, Extent.cx + Settings.CharSpacing);
  end;
end;

function GetLineHeightOf(const Font: HFONT): Word;
var
  DC: HDC;
  OldFont: HFONT;
  Extent: TSize;
begin
  DC := CreateCompatibleDC(0);
  OldFont := SelectObject(DC, Font);
  try
    GetTextExtentPoint32(DC, 'w', 1, Extent);
    Result := Extent.cy
  finally
    SelectObject(DC, OldFont);
    DeleteDC(DC)
  end
end;

procedure DrawFormattedText(const Settings: TDrawFormattedTextSettings);
const
  NewLineChar  = #10;
  BufferHeight = 700;
var
  Canvas: TCanvas;
  MaxWidth: Word;
  DC: HDC;
  Drawing: TDBDraw;
  CurHighlight: TPieceFormatData;
  I, LastHighlight: Integer;
  WrappedText: WideString;
  Current: TPoint;
  Extent: TSize;
begin
  Canvas := Settings.Canvas;
  MaxWidth := Settings.MaxWidth;

  Drawing := DoubleBufferedDraw(Canvas, Point(MaxWidth, 700));
  DC := Drawing.MemDC;
  try
    FillRect(DC, Rect(0, 0, MaxWidth, BufferHeight), Canvas.Brush.Handle);

    if Settings.WrapText then
      WrappedText := wrapNonMonospacedText(Canvas.Handle, Settings.Text, NewLineChar, MaxWidth)
      else
        WrappedText := Settings.Text;

    ZeroMemory(@CurHighlight, SizeOf(CurHighlight));
    LastHighlight := -1;
    Current := Point(0, 0);

    for I := 1 to Length(WrappedText) do
    begin
      if CurHighlight.Position.StrPos + CurHighlight.Position.MatchLength <= I then
      begin
        if LastHighlight = Length(Settings.FormatData) - 1 then
        begin
          CurHighlight.Position.MatchLength := $FFFF;
          CurHighlight.Color := clBlack
        end
          else
          begin
            Inc(LastHighlight);
            CurHighlight := Settings.FormatData[LastHighlight]
          end;

        SetTextColor(DC, ColorToRGB(clBlack))
      end
        else if CurHighlight.Position.StrPos <= I then
          SetTextColor(DC, ColorToRGB(CurHighlight.Color));

      GetTextExtentPoint32W(DC, @WrappedText[I], 1, Extent);

      if WrappedText[I] = NewLineChar then
        Current := Point(4, Current.Y + Extent.cy)
        else
        begin
          TextOutW(DC, Current.X, Current.Y, @WrappedText[I], 1);
          Inc(Current.X, Extent.cx + Settings.CharSpacing)
        end
    end
  finally
    FinishDrawing(Drawing, Settings.DestPos, Point(MaxWidth, Current.Y + Extent.cy))
  end;
end;

function GetLastCharPos(const DC: HDC; const Str: WideString;
 const MaxWidth: Word; const CharSpacing: Word = 0): TSize;
var
  Settings: TWrapTextSettings;
begin
  Settings.DC := DC;
  Settings.Str := Str;
  Settings.Delimiter := #10;
  Settings.MaxWidth := MaxWidth;
  Settings.LeftMargin := 0;
  Settings.CharSpacing := CharSpacing;

  WrapNonMonospacedText(Settings);
  Result := Settings.LastChar;
end;

function WrapNonMonospacedText(const DC: HDC; const Str: WideString;
  const Delimiter: WideString; const MaxWidth: Word; const CharSpacing: Word = 0): WideString;
var
  Settings: TWrapTextSettings;
begin
  Settings.DC := DC;
  Settings.Str := Str;
  Settings.Delimiter := Delimiter;
  Settings.MaxWidth := MaxWidth;
  Settings.LeftMargin := 0;
  Settings.CharSpacing := CharSpacing;

  Result := WrapNonMonospacedText(Settings);
end;

function WrapNonMonospacedText(var Settings: TWrapTextSettings): WideString;
var
  Str, Line: WideString;
  I, LastWrap, Pos: Word;
  LastChar, Extent: TSize;
begin
  Str := Settings.Str;
  LastWrap := 1;
  Result := '';

  LastChar.cx := Settings.LeftMargin;
  LastChar.cy := 0;

  I := 1;
  while I <= Length(Str) do
  begin
    GetTextExtentPoint32W(Settings.DC, @Str[I], 1, Extent);
    Inc(LastChar.cx, Extent.cx + Settings.CharSpacing);
    if LastChar.cx > Settings.MaxWidth then
    begin
      Line := WrapText(Copy(Str, LastWrap, I - LastWrap), Settings.Delimiter, I - LastWrap - 1);
      Pos := PosW(Settings.Delimiter, Line) + Length(Settings.Delimiter) - 1;
      Dec(I, Length(Line) - Pos);
      Line := Copy(Line, 1, Pos);
      Result := Result + Line;
      LastWrap := I;
      Inc(LastChar.cy, Extent.cy);
      LastChar.cx := Settings.LeftMargin
    end
      else
        Inc(I);
  end;

  Settings.LastChar := LastChar;
  Result := Result + Copy(Str, LastWrap, $FFFF);
end;

end.