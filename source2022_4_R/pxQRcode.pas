unit pxQRcode;

interface

uses
  Windows, Classes, Graphics, SysUtils;

const
  QR_ECLEVEL_L    = 0;
  QR_ECLEVEL_M    = 1;
  QR_ECLEVEL_Q    = 2;
  QR_ECLEVEL_H    = 3;

procedure CreateQRCodeBMP(const AText: string; const ABitmapStream: TStream;
  const ALevel: Byte = QR_ECLEVEL_M; const ASize: Integer = 3);

implementation

uses
  Math, StrUtils;

const
  QR_DEFAULT_MASK = 2;

const
  QR_MODE_NUL     = -1;
  QR_MODE_NUM     = 0;
  QR_MODE_AN      = 1;
  QR_MODE_8       = 2;
  QR_MODE_KANJI   = 3;

const
  QRSPEC_VERSION_MAX = 40;

type
  TAByte   = array of Byte;

type
  TQRFrame = array of TAByte;
  TQRMask = TQRFrame;

type
  TEccSpec = array [0 .. 4] of Integer;

type
  TQRSBlock = record
    DataLength: Integer;
    data: TAByte;
    EccLength: Integer;
    ecc: TAByte;
  end;

type
  TQRBitStream = class (TObject)
  private
    FData: array of Boolean;
    function GetSize: Integer;
  public
    procedure ToByte(out ABytes: TAByte);
    procedure Append(const AArg: TQRBitStream);
    procedure AppendNum(const ABits: Byte; ANum: Integer);
    procedure AppendBytes(const ASize: Integer; const AData: TAByte);

    property Size: Integer read GetSize;

    constructor Create; overload;
    constructor Create(const ABits: Byte; const ANum: Integer); overload;
    constructor Create(const ASize: Integer; const AData: TAByte); overload;
  end;

type
  TQRInput = class (TObject)
  private
    FVersion: Integer;
    FLevel: Integer;
    FData: TList;
  public
    property Version: Integer read FVersion;
    property Level: Integer read FLevel;

    class function LookAnTable(const AN: Byte): Integer;
    class function EstimateBitsModeNum(const ASize: Integer): Integer;
    class function EstimateBitsMode8(const ASize: Integer): Integer;
    class function EstimateBitsModeAn(const ASize: Integer): Integer;
    class function EstimateBitsModeKanji(const ASize: Integer): Integer;

    procedure Append(const AMode, ASize: Integer; const AData: TAByte);
    procedure GetByteStream(var AArr: TAByte);
    function GetBitStream: TQRBitStream;
    function MergeBitStream: TQRBitStream;
    procedure AppendPaddingBit(const ABstream: TQRBitStream);
    function ConvertData: Boolean;
    function EstimateVersion: Integer;
    function EstimateBitStreamSize(const AVersion: Integer): Integer;
    function CreateBitStream: Integer;

    constructor Create(const AVersion, ALevel: Integer);
    destructor Destroy; override;
  end;

type
  TQRInputItem = class (TObject)
  private
    FMode: Integer;
    FData: TAByte;
    FBStream: TQRBitStream;
  public
    constructor Create(const AMode, ASize: Integer; AData: TAByte);

    property Bstream: TQRBitStream read FBStream;

    function EstimateBitStreamSizeOfEntry(const AVersion: Integer): Integer;
    function EncodeBitStream(const AVersion: Integer): Integer;
    function EncodeModeNum(const AVersion: Integer): Integer;
    function EncodeModeAn(const AVersion: Integer): Integer;
    function EncodeMode8(const AVersion: Integer): Integer;
    function EncodeModeKanji(const AVersion: Integer): Integer;
  end;

type
  TQRCode = class (TObject)
  private
    FVersion: Integer;
    FWidth: Integer;
    FData: TQRFrame;
  public
    procedure EncodeInput(const AInput: TQRInput);
    procedure EncodeString(const AText: string; const AVersion, ALevel,
      AHint: Integer; const ACasesensetive: Boolean);
  end;

type
  TQREncode = class (TObject)
  private
    FSize: Integer;
    FLevel: Integer;
  public
    constructor Create(const ALevel, ASize: Integer);
    procedure EncodeBitmap(const AText: string; const AStream: TStream);
  end;

type
  TQRSplit = class (TObject)
  private
    FData: TAByte;
    FInput: TQRInput;
    FHint: Integer;
  public
    class procedure SplitStringToQRinput(const AData: string;
      const AInput: TQRInput; const AHint: Integer;
      const ACaseSensetive: Boolean);

    constructor Create(const AData: string; const AInput: TQRInput;
      const AHint: Integer);

    procedure SplitString;
    function IdentifyMode(const APos: Integer): Integer;
    function IsAllNum(const c: Char): Boolean;
    function eatNum: Integer;
    function eatAn: Integer;
    function eatKanji: Integer;
    function eat8: Integer;
  end;

type
  TQRRawCode = class (TObject)
  private
    FDataCode: TAByte;
    FeccCode: TAByte;
    FVersion: Integer;
    FCount: Integer;
    FDataLength: Integer;
    FEccLength: Integer;
    FBlocks: Integer;
    FRSBlocks: array of TQRSBlock;
    Fb1: Integer;
  public
    constructor Create(const AInput: TQRInput);

    property Version: Integer read FVersion;
    property DataLength: Integer read FDataLength;
    property EccLength: Integer read FEccLength;

    function GetCode: Byte;
    procedure Init(const ASpec: TEccSpec);
  end;

type
  TQRFrameFiller = class (TObject)
    FFrame: TQRFrame;
    FWidth: Integer;
    Fx: Integer;
    Fy: Integer;
    Fdir: Integer;
    Fbit: Integer;
  public
    constructor Create(const AWidth: Integer; const AFrame: TQRFrame);
    function Next: TPoint;
    procedure SetFrameAt(const AAddr: TPoint; const AB: Byte);

    property Frame: TQRFrame read FFrame;
  end;

type
  TQRrsItem = class (TObject)
  private
    Fmm: Integer;
    Fnn: Integer;
    Fpad: Integer;
    FalphaTo: TAByte;
    FindexOf: TAByte;
    Fgenpoly: TAByte;
    Ffcr: Integer;
    Fprim: Integer;
    Fnroots: Integer;
    Fgfpoly: Integer;
    Fiprim: Integer;
    function modnn(const AX: Integer): Integer;
  public
    constructor Create(const ASymsize, AGfPoly, AFCR, APrim, ANRoots, APad: Integer);
    procedure EncodeRSChar(const AData: TAByte; var AParity: TAByte);
  end;

procedure QRFrameToBitmap(const ATab: TQRFrame; const AStream: TStream;
  const ASize: Integer); forward;

function MakeQRMask(const AWidth: Integer; const AFrame: TQRFrame;
  const AMask, ALevel: Integer): TQRMask; forward;

function getWidth(Version: Integer): Integer; forward;

function createFrame(Version: Integer): TQRFrame; forward;

function getRemainder(Version: Integer): Integer; forward;

function getDataLength(Version, Level: Integer): Integer; forward;

function getMinimumVersion(Size, Level: Integer): Integer; forward;

function maximumWords(mode, Version: Integer): Integer; forward;

function lengthIndicator(mode, Version: Integer): Integer; forward;

function getEccSpec(Version, Level: Integer): TEccSpec; forward;

procedure StrSet(var srctab: TQRFrame; x, y: Integer; repl: string;
  replLen: Integer = -1); forward;

function getVersionPattern(Version: Integer): Integer; forward;

// -- TQRBitStream

constructor TQRBitStream.Create;
begin
  SetLength(FData, 0);
end;

constructor TQRBitStream.Create(const ABits: Byte; const ANum: Integer);
var
  mask, i: Integer;
begin
  Create;
  SetLength(FData, ABits);
  mask := 1 shl (ABits - 1);
  for i := 0 to ABits - 1 do
  begin
    FData[i] := ANum and mask <> 0;
    mask := mask shr 1;
  end;
end;

constructor TQRBitStream.Create(const ASize: Integer; const AData: TAByte);
var
  p, i, j: Integer;
  mask: Byte;
begin
  Create;
  SetLength(FData, ASize * 8);
  p := 0;

  for i := 0 to ASize - 1 do
  begin
    mask := $80;

    for j := 0 to 7 do
    begin
      FData[p] := AData[i] and mask <> 0;
      inc(p);
      mask := mask shr 1;
    end;
  end;
end;

procedure TQRBitStream.Append(const AArg: TQRBitStream);
var
  p: Integer;
begin
  if not Assigned(AArg) then
    Exit;

  if AArg.Size = 0 then
    Exit;

  p := Length(FData);
  SetLength(FData, p + AArg.Size);
  move(AArg.FData[0], FData[p], AArg.Size);
end;

procedure TQRBitStream.AppendNum(const ABits: Byte; ANum: Integer);
var
  b: TQRBitStream;
begin
  if ABits = 0 then
    Exit;

  b := TQRBitStream.Create(ABits, ANum);
  try
    Append(b);
  finally
    b.Free;
  end;
end;

procedure TQRBitStream.AppendBytes(const ASize: Integer; const AData: TAByte);
var
  b: TQRBitStream;
begin
  if ASize = 0 then
    Exit;

  b := TQRBitStream.Create(ASize, AData);
  try
    Append(b);
  finally
    b.Free;
  end;
end;

function TQRBitStream.GetSize: Integer;
begin
  Result := Length(FData);
end;

procedure TQRBitStream.ToByte(out ABytes: TAByte);
const
  dv: array [Boolean] of Byte = (0, 1);
var
  Size, bytes, p, i, j, v: Integer;
begin
  Size := Length(FData);
  if Size = 0 then
  begin
    SetLength(ABytes, 0);
    Exit;
  end;

  SetLength(ABytes, (Size + 7) div 8);
  FillChar(ABytes[0], (Size + 7) div 8, 0);
  bytes := Size div 8;
  p := 0;

  for i := 0 to bytes - 1 do
  begin
    v := 0;
    j := 0;

    while j < 8 do
    begin
      v := (v shl 1) or dv[FData[p]];
      inc(p);
      inc(j);
    end;

    ABytes[i] := v;
  end;

  if (Size and 7) <> 0 then
  begin
    v := 0;

    for j := 0 to 7 do
    begin
      v := (v shl 1) or dv[FData[p]];
      inc(p);
    end;

    ABytes[bytes] := v;
  end;
end;

// -- TQRCode

procedure TQRCode.EncodeString(const AText: string; const AVersion, ALevel,
  AHint: Integer; const ACasesensetive: Boolean);
var
  input: TQRInput;
begin
  input := TQRInput.Create(AVersion, ALevel);
  TQRSplit.SplitStringToQRinput(AText, input, AHint, ACasesensetive);
  EncodeInput(input);
end;

procedure TQRCode.EncodeInput(const AInput: TQRInput);
var
  raw: TQRRawCode;
  width: Integer;
  i, j: Integer;
  frame: TQRFrame;
  filler: TQRFrameFiller;
  code, bit: Byte;
  addr: TPoint;
  masked: TQRMask;
begin
  if (AInput.Version < 0) or (AInput.Version > QRSPEC_VERSION_MAX) or
     (AInput.Level > QR_ECLEVEL_H) then
    Exit;

  raw := TQRRawCode.Create(AInput);

  width := getWidth(raw.Version);
  frame := createFrame(raw.Version);

  filler := TQRFrameFiller.Create(width, frame);

  try
    for i := 0 to raw.DataLength + raw.EccLength - 1 do
    begin
      code := raw.GetCode;
      bit := $80;

      for j := 0 to 7 do
      begin
        addr := filler.Next;

        filler.SetFrameAt(addr, $02 + IfThen((bit and code) <> 0, 1, 0));

        bit := bit shr 1;
      end;
    end;

    FVersion := raw.Version;

    j := getRemainder(raw.Version);
    for i := 0 to j - 1 do
    begin
      addr := filler.Next;
      filler.SetFrameAt(addr, $02);
    end;

    for i := 0 to Length(frame) - 1 do
      move(filler.frame[i][0], frame[i][0], Length(frame[i]));

    masked := MakeQRMask(width, frame, QR_DEFAULT_MASK, AInput.Level);

    FWidth := width;
    FData := masked;
  finally
    filler.Free;
    raw.Free;
  end;
end;

// -- TQREncode

constructor TQREncode.Create(const ALevel, ASize: Integer);
begin
  FSize := ASize;
  FLevel := ALevel;
end;

procedure TQREncode.EncodeBitmap(const AText: string; const AStream: TStream);
var
  tab: TQRFrame;
  q: TQRCode;
  i: Integer;
begin
  SetLength(tab, 0);

  q := TQRCode.Create;
  try
    q.EncodeString(AText, 0, FLevel, QR_MODE_8, True);
    SetLength(tab, Length(q.FData));

    for i := 0 to q.FWidth - 1 do
    begin
      SetLength(tab[i], Length(q.FData[i]));
      move(q.FData[i][0], tab[i][0], Length(tab[i]));
    end;
  finally
    q.Free;
  end;

  QRFrameToBitmap(tab, AStream, FSize);
end;

// -- TQRFrameFiller

constructor TQRFrameFiller.Create(const AWidth: Integer; const AFrame: TQRFrame);
var
  i: Integer;
begin
  FWidth := AWidth;
  SetLength(FFrame, Length(AFrame));

  for i := 0 to Length(AFrame) - 1 do
  begin
    SetLength(FFrame[i], Length(AFrame[i]));
    move(AFrame[i][0], FFrame[i][0], Length(FFrame[i]));
  end;

  Fx := AWidth - 1;
  Fy := AWidth - 1;
  Fdir := -1;
  Fbit := -1;
end;

function TQRFrameFiller.Next;
var
  x, y, w: Integer;
begin
  repeat
    if Fbit = -1 then
    begin
      Fbit := 0;
      Result.x := Fx;
      Result.y := Fy;
      Exit;
    end;

    x := Fx;
    y := Fy;
    w := FWidth;

    if Fbit = 0 then
    begin
      dec(x);
      inc(Fbit);
    end else
    begin
      inc(x);
      inc(y, Fdir);
      dec(Fbit);
    end;

    if Fdir < 0 then
    begin
      if y < 0 then
      begin
        y := 0;
        dec(x, 2);
        Fdir := 1;

        if x = 6 then
        begin
          dec(x);
          y := 9;
        end;
      end;
    end else
    begin
      if y = w then
      begin
        y := w - 1;
        dec(x, 2);
        Fdir := -1;

        if x = 6 then
        begin
          dec(x);
          dec(y, 8);
        end;
      end;
    end;

    if (x < 0) or (y < 0) then
    begin
      Result.x := -1;
      Result.y := -1;
      Exit;
    end;

    Fx := x;
    Fy := y;
  until FFrame[y][x] and $80 = 0;

  Result.x := x;
  Result.y := y;
end;

procedure TQRFrameFiller.SetFrameAt(const AAddr: TPoint; const AB: Byte);
begin
  FFrame[AAddr.y][AAddr.x] := AB;
end;

// -- TQRInput

constructor TQRInput.Create(const AVersion, ALevel: Integer);
begin
  FData := TList.Create;
  if (AVersion < 0) or (AVersion > QRSPEC_VERSION_MAX) or (ALevel > QR_ECLEVEL_H)
  then
    Exit;
  FVersion := AVersion;
  FLevel := ALevel;
end;

destructor TQRInput.Destroy;
var
  i: Integer;
begin
  for i := 0 to FData.Count - 1 do
    TQRInputItem(FData.Items[i]).Free;

  FData.Free;
end;

procedure TQRInput.Append(const AMode, ASize: Integer; const AData: TAByte);
begin
  FData.Add(TQRInputItem.Create(AMode, ASize, AData));
end;

procedure TQRInput.AppendPaddingBit(const ABstream: TQRBitStream);
var
  words, bits, maxwords, maxbits, padlen, i: Integer;
  padding: TQRBitStream;
  padbuf: TAByte;
begin
  bits := ABstream.Size;
  maxwords := getDataLength(FVersion, FLevel);
  maxbits := maxwords * 8;
  if maxbits = bits then
    Exit;
  if maxbits - bits < 5 then
  begin
    ABstream.AppendNum(maxbits - bits, 0);
    Exit;
  end;
  inc(bits, 4);
  words := (bits + 7) div 8;
  padding := TQRBitStream.Create;
  padding.AppendNum(words * 8 - bits + 4, 0);
  padlen := maxwords - words;
  if padlen > 0 then
  begin
    SetLength(padbuf, padlen);
    for i := 0 to padlen - 1 do
      if i and 1 = 1 then
        padbuf[i] := $11
      else
        padbuf[i] := $EC;
    padding.AppendBytes(padlen, padbuf);
  end;
  ABstream.Append(padding);
end;

function TQRInput.ConvertData: Boolean;
var
  ver: Integer;
  bits: Integer;
begin
  Result := false;
  ver := EstimateVersion;

  if ver > Version then
    FVersion := ver;

  while True do
  begin
    bits := CreateBitStream;
    if bits < 0 then
      Exit;

    ver := getMinimumVersion((bits + 7) div 8, FLevel);

    if ver < 0 then
      Exit
    else
    if ver > Version then
      FVersion := ver
    else
      break;
  end;

  Result := True;
end;

function TQRInput.CreateBitStream: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FData.Count - 1 do
    inc(Result, TQRInputItem(FData.Items[i]).EncodeBitStream(FVersion));
end;

class function TQRInput.EstimateBitsMode8(const ASize: Integer): Integer;
begin
  Result := ASize * 8;
end;

class function TQRInput.EstimateBitsModeAn(const ASize: Integer): Integer;
var
  w: Integer;
begin
  w := ASize div 2;
  Result := w * 11;
  if ASize and 1 = 1 then
    inc(Result, 6)
end;

class function TQRInput.EstimateBitsModeKanji(const ASize: Integer): Integer;
begin
  Result := (ASize div 2) * 13;
end;

class function TQRInput.EstimateBitsModeNum(const ASize: Integer): Integer;
var
  w: Integer;
begin
  w := ASize div 3;
  Result := w * 10;
  case ASize - w * 3 of
    1:
      inc(Result, 4);
    2:
      inc(Result, 7);
  end;
end;

function TQRInput.EstimateBitStreamSize(const AVersion: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FData.Count - 1 do
    inc(Result, TQRInputItem(FData.Items[i]).EstimateBitStreamSizeOfEntry
      (AVersion));
end;

function TQRInput.EstimateVersion: Integer;
var
  prev: Integer;
begin
  Result := 0;
  repeat
    prev := Result;
    Result := getMinimumVersion((EstimateBitStreamSize(prev) + 7)
      div 8, FLevel);
  until Result <= prev;
end;

function TQRInput.GetBitStream;
begin
  Result := MergeBitStream;
  if Assigned(Result) then
    AppendPaddingBit(Result);
end;

procedure TQRInput.GetByteStream(var AArr: TAByte);
var
  bstream: TQRBitStream;
begin
  bstream := GetBitStream;
  try
    bstream.ToByte(AArr);
  finally
    bstream.Free;
  end;
end;

function TQRInput.MergeBitStream;
var
  i: Integer;
begin
  Result := TQRBitStream.Create;
  if ConvertData then
    for i := 0 to FData.Count - 1 do
      Result.Append(TQRInputItem(FData.Items[i]).bstream);
end;

class function TQRInput.LookAnTable(const AN: Byte): Integer;
const
  anTable: array [0 .. 127] of Integer = (-1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, 36, -1, -1, -1, 37, 38, -1, -1, -1, -1, 39, 40, -1, 41, 42,
    43, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 44, -1, -1, -1, -1, -1, -1, 10, 11, 12,
    13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
    32, 33, 34, 35, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1);
begin
  Result := IfThen(AN > 127, -1, anTable[AN and 127]);
end;

// -- TQRInputItem

constructor TQRInputItem.Create(const AMode, ASize: Integer; AData: TAByte);
begin
  SetLength(FData, ASize);
  move(AData[0], FData[0], ASize);
  FMode := AMode;
end;

function TQRInputItem.EncodeBitStream(const AVersion: Integer): Integer;
var
  words, ret: Integer;
  st1, st2: TQRInputItem;
  data2: TAByte;
begin
  if Assigned(FBStream) then
    FBStream.Free;

  words := maximumWords(FMode, AVersion);
  if Length(FData) > words then
  begin
    st1 := TQRInputItem.Create(FMode, words, FData);
    SetLength(data2, Length(FData) - words);
    move(FData[words], data2[0], Length(FData) - words);
    st2 := TQRInputItem.Create(FMode, Length(FData) - words, data2);
    st1.EncodeBitStream(AVersion);
    st2.EncodeBitStream(AVersion);
    FBStream := TQRBitStream.Create;
    FBStream.Append(st1.bstream);
    FBStream.Append(st2.bstream);

    st1.Free;
    st2.Free;
  end
  else
  begin
    ret := 0;
    case FMode of
      QR_MODE_NUM:
        ret := EncodeModeNum(AVersion);
      QR_MODE_AN:
        ret := EncodeModeAn(AVersion);
      QR_MODE_8:
        ret := EncodeMode8(AVersion);
      QR_MODE_KANJI:
        ret := EncodeModeKanji(AVersion);
    end;

    if ret < 0 then begin
      result:= -1;
    end;
      //Exit(-1);
  end;
  Result := FBStream.Size;
end;

function TQRInputItem.EncodeMode8(const AVersion: Integer): Integer;
var
  i: Integer;
begin
  FBStream := TQRBitStream.Create;
  FBStream.AppendNum(4, $04);
  FBStream.AppendNum(lengthIndicator(QR_MODE_8, AVersion),
    Length(FData));

  for i := 0 to Length(FData) - 1 do
    FBStream.AppendNum(8, FData[i]);

  Result := 0;
end;

function TQRInputItem.EncodeModeAn(const AVersion: Integer): Integer;
var
  words, i: Integer;
  val: Integer;
begin
  words := Length(FData) div 2;
  FBStream := TQRBitStream.Create;
  FBStream.AppendNum(4, $02);
  FBStream.AppendNum(lengthIndicator(QR_MODE_AN, AVersion), Length(FData));

  for i := 0 to words - 1 do
  begin
    val := TQRInput.LookAnTable(FData[i * 2]) * 45 + TQRInput.LookAnTable
      (FData[i * 2 + 1]);

    FBStream.AppendNum(11, val);
  end;

  if Length(FData) and 1 = 1 then
  begin
    val := TQRInput.LookAnTable(FData[words * 2]);
    FBStream.AppendNum(6, val);
  end;

  Result := 0;
end;

function TQRInputItem.EncodeModeKanji(const AVersion: Integer): Integer;
var
  i: Integer;
  val: word;
  h: word;
begin
  FBStream := TQRBitStream.Create;
  FBStream.AppendNum(4, $08);
  FBStream.AppendNum(lengthIndicator(QR_MODE_KANJI, AVersion), Length(FData) div 2);

  i := 0;
  while i < Length(FData) do
  begin
    val := (FData[i] shl 8) or FData[i + 1];
    if val <= $9FFC then
      val := val - $8140
    else
      val := val - $C140;

    h := (val shr 8) * $C0;
    val := (val and $FF) + h;
    FBStream.AppendNum(13, val);
    inc(i, 2);
  end;
  Result := 0;
end;

function TQRInputItem.EncodeModeNum(const AVersion: Integer): Integer;
var
  words, i: Integer;
  val: Integer;
begin
  words := Length(FData) div 3;
  FBStream := TQRBitStream.Create;
  val := 1;
  FBStream.AppendNum(4, val);
  FBStream.AppendNum(lengthIndicator(QR_MODE_NUM, AVersion), Length(FData));

  for i := 0 to words - 1 do
  begin
    val := (FData[i * 3] - Ord('0')) * 100 + (FData[i * 3 + 1] - Ord('0')) * 10
      + (FData[i * 3 + 2] - Ord('0'));

    FBStream.AppendNum(10, val);
  end;

  if Length(FData) - words * 3 = 1 then
  begin
    val := FData[words * 3] - Ord('0');
    FBStream.AppendNum(4, val);
  end
  else
  if Length(FData) - words * 3 = 2 then
  begin
    val := (FData[words * 3] - Ord('0')) * 10 +
      (FData[words * 3 + 1] - Ord('0'));

    FBStream.AppendNum(7, val);
  end;

  Result := 0;
end;

function TQRInputItem.EstimateBitStreamSizeOfEntry(const AVersion: Integer): Integer;
var
  l, m, num: Integer;
begin
  Result := 0;

  case FMode of
    QR_MODE_NUM:
      Result := TQRInput.EstimateBitsModeNum(Length(FData));
    QR_MODE_AN:
      Result := TQRInput.EstimateBitsModeAn(Length(FData));
    QR_MODE_8:
      Result := TQRInput.EstimateBitsMode8(Length(FData));
    QR_MODE_KANJI:
      Result := TQRInput.EstimateBitsModeKanji(Length(FData));
  else
    Exit;
  end;

  l := lengthIndicator(FMode, IfThen(AVersion = 0, 1, AVersion));
  m := 1 shl l;
  num := (Length(FData) + m - 1) div m;
  inc(Result, num * (4 + l));
end;

// -- TQRRawCode

constructor TQRRawCode.Create(const AInput: TQRInput);
var
  spec: TEccSpec;
begin
  FillChar(spec[0], 20, 0);

  AInput.GetByteStream(FDataCode);
  spec := getEccSpec(AInput.Version, AInput.Level);
  FVersion := AInput.Version;

  Fb1 := spec[0];
  FDataLength := spec[0] * spec[1] + spec[3] * spec[4];

  FEccLength := (spec[0] + spec[3]) * spec[2];
  SetLength(FeccCode, FEccLength);
  FillChar(FeccCode[0], FEccLength, 0);

  FBlocks := spec[0] + spec[3];
  SetLength(FRSBlocks, FBlocks);

  init(spec);

  FCount := 0;
end;

procedure TQRRawCode.Init(const ASpec: TEccSpec);
var
  dl, el: Byte;
  rs: TQRrsItem;
  blockNo, dataPos, eccPos, i: Integer;
  ecc: TAByte;
begin
  dl := ASpec[1];
  el := ASpec[2];
  rs := TQRrsItem.Create(8, $11D, 0, 1, el, 255 - dl - el);

  blockNo := 0;
  dataPos := 0;
  eccPos  := 0;

  for i := 0 to ASpec[0] - 1 do
  begin
    SetLength(ecc, FEccLength - eccPos);
    move(FeccCode[eccPos], ecc[0], FEccLength - eccPos);

    FRSBlocks[blockNo].DataLength := dl;

    SetLength(FRSBlocks[blockNo].data, dl);
    move(FDataCode[dataPos], FRSBlocks[blockNo].data[0], dl);

    rs.EncodeRSChar(FRSBlocks[blockNo].data, ecc);
    FRSBlocks[blockNo].EccLength := el;

    SetLength(FRSBlocks[blockNo].ecc, el);
    move(ecc[0], FRSBlocks[blockNo].ecc[0], el);

    SetLength(FeccCode, eccPos + el);
    move(ecc[0], FeccCode[eccPos], el);

    inc(dataPos, dl);
    inc(eccPos, el);
    inc(blockNo);
  end;

  if ASpec[3] = 0 then
    Exit;

  dl := ASpec[4];
  el := ASpec[2];

  rs := TQRrsItem.Create(8, $11D, 0, 1, el, 255 - dl - el);

  for i := 0 to ASpec[3] - 1 do
  begin
    SetLength(ecc, FEccLength - eccPos);
    move(FeccCode[eccPos], ecc[0], FEccLength - eccPos);

    FRSBlocks[blockNo].DataLength := dl;

    SetLength(FRSBlocks[blockNo].data, dl);
    move(FDataCode[dataPos], FRSBlocks[blockNo].data[0], dl);

    rs.EncodeRSChar(FRSBlocks[blockNo].data, ecc);
    FRSBlocks[blockNo].EccLength := el;

    SetLength(FRSBlocks[blockNo].ecc, el);
    move(ecc[0], FRSBlocks[blockNo].ecc[0], el);

    SetLength(FeccCode, eccPos + el);
    move(ecc[0], FeccCode[eccPos], el);

    inc(dataPos, dl);
    inc(eccPos, el);
    inc(blockNo);
  end;
end;

function TQRRawCode.GetCode;
var
  row, col: Integer;
begin
  Result := 0;

  if FCount < FDataLength then
  begin
    row := FCount mod FBlocks;
    col := FCount div FBlocks;

    if col >= FRSBlocks[0].DataLength then
      inc(row, Fb1);

    Result := FRSBlocks[row].data[col];
  end else
  if FCount < FDataLength + FEccLength then
  begin
    row := (FCount - FDataLength) mod FBlocks;
    col := (FCount - FDataLength) div FBlocks;

    Result := FRSBlocks[row].ecc[col];
  end else
    Exit;

  inc(FCount);
end;

// -- TQRrsItem

constructor TQRrsItem.Create(const ASymsize, AGfPoly, AFCR, APrim, ANRoots,
  APad: Integer);
var
  i, j, sr, root: Integer;
begin
  if (ASymsize < 0) or (ASymsize > 8) then
    Exit;
  if (AFCR < 0) or (AFCR >= (1 shl ASymsize)) then
    Exit;
  if (APrim <= 0) or (APrim >= (1 shl ASymsize)) then
    Exit;
  if (ANRoots < 0) or (ANRoots >= (1 shl ASymsize)) then
    Exit;
  if (APad < 0) or (APad >= ((1 shl ASymsize) - 1 - ANRoots)) then
    Exit;
  Fmm := ASymsize;
  Fnn := (1 shl ASymsize) - 1;
  Fpad := APad;
  SetLength(FalphaTo, Fnn + 1);
  FillChar(FalphaTo[0], Length(FalphaTo), 0);
  SetLength(FindexOf, Fnn + 1);
  FillChar(FindexOf[0], Length(FindexOf), 0);

  FindexOf[0] := Fnn;
  FalphaTo[Fnn] := 0;

  sr := 1;
  for i := 0 to Fnn - 1 do
  begin
    FindexOf[sr] := i;
    FalphaTo[i] := sr;
    sr := sr shl 1;
    if (sr and (1 shl ASymsize)) <> 0 then
      sr := sr xor AGfPoly;
    sr := sr and Fnn;
  end;
  if (sr <> 1) then
    Exit;
  SetLength(Fgenpoly, ANRoots + 1);
  FillChar(Fgenpoly[0], Length(Fgenpoly), 0);
  Ffcr := AFCR;
  Fprim := APrim;
  Fnroots := ANRoots;
  Fgfpoly := AGfPoly;

  i := 1;
  while i mod APrim <> 0 do
    inc(i, Fnn);
  Fiprim := i div APrim;
  Fgenpoly[0] := 1;
  root := AFCR * APrim;
  for i := 0 to ANRoots - 1 do
  begin
    Fgenpoly[i + 1] := 1;
    for j := i downto 1 do
      if Fgenpoly[j] <> 0 then
        Fgenpoly[j] := Fgenpoly[j - 1] xor FalphaTo
          [modnn(FindexOf[Fgenpoly[j]] + root)]
      else
        Fgenpoly[j] := Fgenpoly[j - 1];
    Fgenpoly[0] := FalphaTo[modnn(FindexOf[Fgenpoly[0]] + root)];
    inc(root, APrim);
  end;
  for i := 0 to ANRoots do
    Fgenpoly[i] := FindexOf[Fgenpoly[i]];
end;

procedure TQRrsItem.EncodeRSChar(const AData: TAByte; var AParity: TAByte);
var
  i, j: Integer;
  feedback: Byte;
begin
  SetLength(AParity, Fnroots);
  FillChar(AParity[0], Fnroots, 0);
  for i := 0 to Fnn - Fnroots - Fpad - 1 do
  begin
    feedback := FindexOf[AData[i] xor AParity[0]];
    if feedback <> Fnn then
    begin
      feedback := modnn(Fnn - Fgenpoly[Fnroots] + feedback);
      for j := 1 to Fnroots - 1 do
        AParity[j] := AParity[j] xor FalphaTo
          [modnn(feedback + Fgenpoly[Fnroots - j])];
    end;
    for j := 1 to Length(AParity) - 1 do
      AParity[j - 1] := AParity[j];
    if feedback <> Fnn then
      AParity[Length(AParity) - 1] := FalphaTo[modnn(feedback + Fgenpoly[0])]
    else
      AParity[Length(AParity) - 1] := 0;
  end;
end;

function TQRrsItem.modnn(const AX: Integer): Integer;
var
  x: Integer;
begin
  x := AX;
  while x >= Fnn do
  begin
    dec(x, Fnn);
    x := (x shr Fmm) + (x and Fnn);
  end;
  Result := x;
end;

// -- TQRSplit

constructor TQRSplit.Create(const AData: string; const AInput: TQRInput;
  const AHint: Integer);
var
  i: Integer;
begin
  Setlength(FData, Length(AData));
  for i := 1 to Length(AData) do
    fdata[i-1] := Byte(AData[i]);

  FInput := AInput;
  FHint := AHint;
end;

function TQRSplit.eat8;
var
  la, ln, p, q, dif, mode, dataStrLen: Integer;
begin
  la := lengthIndicator(QR_MODE_AN, FInput.Version);
  ln := lengthIndicator(QR_MODE_NUM, FInput.Version);

  p := 0;
  dataStrLen := Length(FData);

  while p < dataStrLen do
  begin
    mode := IdentifyMode(p);
    if mode = QR_MODE_KANJI then
      break;

    if mode = QR_MODE_NUM then
    begin
      q := p;
      while (q < Length(FData)) and (chr(FData[q]) in ['0' .. '9']) do
        inc(q);

      dif := TQRInput.EstimateBitsMode8(p) + TQRInput.EstimateBitsModeNum(q - p)
        + 4 + ln - TQRInput.EstimateBitsMode8(q);

      if dif < 0 then
        break;

      p := q;
    end else
    if mode = QR_MODE_AN then
    begin
      q := p;
      while (q < Length(FData)) and IsAllNum(chr(FData[q])) do
        inc(q);

      dif := TQRInput.EstimateBitsMode8(p) + TQRInput.EstimateBitsModeAn(q - p)
        + 4 + la - TQRInput.EstimateBitsMode8(q);

      if dif < 0 then
        break;

      p := q;
    end else
      inc(p);
  end;

  Result := p;

  FInput.Append(QR_MODE_8, Result, TAByte(FData));
end;

function TQRSplit.eatAn: Integer;
var
  la, ln, p, q, dif: Integer;
begin
  la := lengthIndicator(QR_MODE_AN, FInput.Version);
  ln := lengthIndicator(QR_MODE_NUM, FInput.Version);

  p := 0;
  while (Length(FData) > p) and IsAllNum(chr(FData[p])) do
  begin
    if chr(FData[p]) in ['0' .. '9'] then
    begin
      q := p;

      while (Length(FData) > p) and (chr(FData[q]) in ['0' .. '9']) do
        inc(q);

      dif := TQRInput.EstimateBitsModeAn(p) + TQRInput.EstimateBitsModeNum
        (q - p) + 4 + ln - TQRInput.EstimateBitsModeAn(q);

      if dif < 0 then
        break;

      p := q;
    end else
      inc(p);
  end;

  q := p;
  if (p > Length(FData)) or not IsAllNum(chr(FData[p])) then
  begin
    dif := TQRInput.EstimateBitsModeAn(q) + 4 + la + TQRInput.EstimateBitsMode8
      (1) - TQRInput.EstimateBitsMode8(q + 1);

    if dif > 0 then begin
      result:= eat8;
      Exit;
    end;
  end;

  Result := q;
  FInput.Append(QR_MODE_AN, q, TAByte(FData));
end;

function TQRSplit.eatKanji;
var
  p: Integer;
begin
  p := 0;
  while IdentifyMode(p) = QR_MODE_KANJI do
    inc(p, 2);

  Result := p;
  FInput.Append(QR_MODE_KANJI, p, TAByte(FData));
end;

function TQRSplit.eatNum: Integer;
var
  ln, p, run, mode, dif: Integer;
begin
  ln := lengthIndicator(QR_MODE_NUM, FInput.Version);
  p := 0;

  while (Length(FData) > p) and (chr(FData[p]) in ['0' .. '9']) do
    inc(p);

  run := p;

  mode := IdentifyMode(p);
  if mode = QR_MODE_8 then
  begin
    dif := TQRInput.EstimateBitsModeNum(run) + 4 + ln +
      TQRInput.EstimateBitsMode8(1) - TQRInput.EstimateBitsMode8(run + 1);

    if dif > 0 then begin
      result:= eat8;
      Exit;
    end;

  end;

  if mode = QR_MODE_AN then
  begin
    dif := TQRInput.EstimateBitsModeNum(run) + 4 + ln +
      TQRInput.EstimateBitsModeAn(1) - TQRInput.EstimateBitsModeAn(run + 1);

    if dif > 0 then begin
      result:= eatAn;
      Exit;
    end;
  end;

  Result := run;
  FInput.Append(QR_MODE_NUM, Result, TAByte(FData));
end;

function TQRSplit.IdentifyMode(const APos: Integer): Integer;
var
  c, d: Char;
  word: System.Word;
begin
  Result := QR_MODE_8;

  if APos >= Length(FData) then  begin
    result:= QR_MODE_NUL;
    Exit;
  end;


  c := chr(FData[APos]);
  if c in ['0' .. '9'] then begin
    //Exit(QR_MODE_NUM)
    result:= QR_MODE_NUM;
    Exit
  end
  else
  if IsAllNum(c) then begin
    result:= QR_MODE_AN;
    Exit;
  end
    //Exit(QR_MODE_AN)
  else
  if FHint = QR_MODE_KANJI then
  begin
    if APos + 1 < Length(FData) then
    begin
      d := chr(FData[APos + 1]);
      word := (Ord(c) shl 8) or Ord(d);

      if ((word >= $8140) and (word <= $9FFC)) or
         ((word >= $E040) and (word <= $EBBF)) then begin
           result:= QR_MODE_AN;
            Exit;
         end;
        //Exit(QR_MODE_AN);
    end;
  end;
end;

function TQRSplit.IsAllNum(const c: Char): Boolean;
begin
  Result := TQRInput.LookAnTable(Ord(c)) <> -1;
end;

procedure TQRSplit.SplitString;
var
  mode, len, i: Integer;
begin
  while Length(FData) > 0 do
  begin
    mode := IdentifyMode(0);
    case mode of
      QR_MODE_NUM:
        len := eatNum;
      QR_MODE_AN:
        len := eatAn;
      QR_MODE_KANJI:
        if FHint = QR_MODE_KANJI then
          len := eatKanji
        else
          len := eat8;
    else
      len := eat8;
    end;

    if len <= 0 then
      Exit;

    for i := len to Length(FData) - 1 do
      FData[i - len] := FData[i];

    SetLength(FData, Length(FData) - len);
  end;
end;

class procedure TQRSplit.SplitStringToQRinput(const AData: string;
  const AInput: TQRInput; const AHint: Integer;
  const ACaseSensetive: Boolean);
var
  split: TQRSplit;
begin
  split := TQRSplit.Create(IfThen(ACaseSensetive, AData, UpperCase(AData)),
    AInput, AHint);
  try
    split.SplitString;
  finally
    split.Free;
  end;
end;

procedure QRFrameToBitmap(const ATab: TQRFrame; const AStream: TStream;
  const ASize: Integer);
var
  b: TBitmap;
  x, y, s1, s2: Integer;
begin
  b := TBitmap.Create;
  try
    b.width := ASize * Length(ATab[0]);
    b.Height := ASize * Length(ATab);

    for y := 0 to Length(ATab) - 1 do
      for x := 0 to Length(ATab[y]) - 1 do
        for s1 := 0 to ASize - 1 do
          for s2 := 0 to ASize - 1 do
            b.Canvas.Pixels[x * ASize + s1, y * ASize + s2] :=
              IfThen((ATab[y, x] and 1) = 1, clBlack, clWhite);

    b.SaveToStream(AStream);
  finally
    b.Free;
  end;
end;

procedure CreateQRCodeBMP(const AText: string; const ABitmapStream: TStream;
  const ALevel: Byte; const ASize: Integer);
var
  enc: TQREncode;
begin
  enc := TQREncode.Create(ALevel, ASize);
  try
    enc.EncodeBitmap(AText, ABitmapStream);
  finally
    enc.Free;
  end;
end;

function lengthIndicator(mode, Version: Integer): Integer;
const
  lengthTableBits: array [0 .. 3, 0 .. 2] of Integer = (
    (10, 12, 14),
    (9 , 11, 13),
    (8 , 16, 16),
    (8 , 10, 12));
var
  l: Integer;
begin
  if (Version <= 9) then
    l := 0
  else
  if Version <= 26 then
    l := 1
  else
    l := 2;

  Result := lengthTableBits[mode][l];
end;

function getWidth(Version: Integer): Integer;
const
  capacity: array [0 .. 40] of Integer = (0, 21, 25, 29, 33, 37, 41, 45, 49, 53,
    57, 61, 65, 69, 73, 77, 81, 85, 89, 93, 97, 101, 105, 109, 113, 117, 121,
    125, 129, 133, 137, 141, 145, 149, 153, 157, 161, 165, 169, 173, 177);
begin
  Result := capacity[Version];
end;

function getRemainder(Version: Integer): Integer;
const
  capacity: array [0 .. 40] of Integer = (0, 0, 7, 7, 7, 7, 7, 0, 0, 0, 0, 0, 0,
    0, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 0, 0,
    0, 0, 0, 0);
begin
  Result := capacity[Version];
end;

procedure putFinderPattern(var frame: TQRFrame; x, y: Integer);
const
  finder: array [0 .. 6] of string = (
    #$00C1#$00C1#$00C1#$00C1#$00C1#$00C1#$00C1,
    #$00C1#$00C0#$00C0#$00C0#$00C0#$00C0#$00C1,
    #$00C1#$00C0#$00C1#$00C1#$00C1#$00C0#$00C1,
    #$00C1#$00C0#$00C1#$00C1#$00C1#$00C0#$00C1,
    #$00C1#$00C0#$00C1#$00C1#$00C1#$00C0#$00C1,
    #$00C1#$00C0#$00C0#$00C0#$00C0#$00C0#$00C1,
    #$00C1#$00C1#$00C1#$00C1#$00C1#$00C1#$00C1);
var
  i: Integer;
begin
  for i := 0 to 6 do
    StrSet(frame, x, y + i, finder[i]);
end;

procedure putAlignmentPattern(Version: Integer; var frame: TQRFrame;
  width: Integer);
const
  alignmentPattern: array [0 .. 40, 0 .. 1] of Byte = (
    (0, 0)  ,
    (0, 0)  , (18, 0),  (22, 0) , (26, 0) , (30, 0) , // 1- 5
    (34, 0) , (22, 38), (24, 42), (26, 46), (28, 50), // 6-10
    (30, 54), (32, 58), (34, 62), (26, 46), (26, 48), // 11-15
    (26, 50), (30, 54), (30, 56), (30, 58), (34, 62), // 16-20
    (28, 50), (26, 50), (30, 54), (28, 54), (32, 58), // 21-25
    (30, 58), (34, 62), (26, 50), (30, 54), (26, 52), // 26-30
    (30, 56), (34, 60), (30, 58), (34, 62), (30, 54), // 31-35
    (24, 50), (28, 54), (32, 58), (26, 54), (30, 58)  // 35-40
    );

  procedure putAlignmentMarker(x, y: Integer);
  const
    marker: array [0 .. 4] of string = (
      #$00A1#$00A1#$00A1#$00A1#$00A1,
      #$00A1#$00A0#$00A0#$00A0#$00A1,
      #$00A1#$00A0#$00A1#$00A0#$00A1,
      #$00A1#$00A0#$00A0#$00A0#$00A1,
      #$00A1#$00A1#$00A1#$00A1#$00A1);
  var
    i: Integer;
  begin
    for i := 0 to 4 do
      StrSet(frame, x - 2, y - 2 + i, marker[i]);
  end;

var
  d, w, cx, x, cy, y: Integer;
begin
  if Version < 2 then
    Exit;
  d := alignmentPattern[Version][1] - alignmentPattern[Version][0];
  if d < 0 then
    w := 2
  else
    w := ((width - alignmentPattern[Version][0]) div d + 2);
  if w * w - 3 = 1 then
  begin
    putAlignmentMarker(alignmentPattern[Version][0],
      alignmentPattern[Version][0]);
    Exit;
  end;
  cx := alignmentPattern[Version][0];
  for x := 1 to w - 2 do
  begin
    putAlignmentMarker(6, cx);
    putAlignmentMarker(cx, 6);
    inc(cx, d)
  end;
  cy := alignmentPattern[Version][0];
  for y := 0 to w - 2 do
  begin
    cx := alignmentPattern[Version][0];
    for x := 0 to w - 2 do
    begin
      putAlignmentMarker(cx, cy);
      inc(cx, d);
    end;
    inc(cy, d)
  end;
end;

function createFrame(Version: Integer): TQRFrame;
var
  width, yOffset, x, y: Integer;
  i: Integer;
  setPattern: string;
  v, vinf: Integer;
begin
  width := getWidth(Version);
  SetLength(Result, width);
  for i := 0 to width - 1 do
  begin
    SetLength(Result[i], width);
    FillChar(Result[i][0], width, 0);
  end;
  putFinderPattern(Result, 0, 0);
  putFinderPattern(Result, width - 7, 0);
  putFinderPattern(Result, 0, width - 7);
  yOffset := width - 7;
  for y := 0 to 6 do
  begin
    Result[y][7] := $C0;
    Result[y][width - 8] := $C0;
    Result[yOffset][7] := $C0;
    inc(yOffset);
  end;
  SetLength(setPattern, 8);
//  FillChar(setPattern[1], 8, #$c0);
  setPattern := StringOfChar(#$00C0, 8);
  StrSet(Result, 0, 7, setPattern);
  StrSet(Result, width - 8, 7, setPattern);
  StrSet(Result, 0, width - 8, setPattern);
  SetLength(setPattern, 9);
//  FillChar(setPattern[1], 9, #$84);
  setPattern := StringOfChar(#$0084, 9);
  StrSet(Result, 0, 8, setPattern);
  StrSet(Result, width - 8, 8, setPattern, 8);
  yOffset := width - 8;
  for y := 0 to 7 do
  begin
    Result[y][8] := $84;
    Result[yOffset][8] := $84;
    inc(yOffset);
  end;
  for i := 1 to width - 16 do
  begin
    Result[6][7 + i] := $90 or (i and 1);
    Result[7 + i][6] := $90 or (i and 1);
  end;
  putAlignmentPattern(Version, Result, width);
  if Version >= 7 then
  begin
    vinf := getVersionPattern(Version);
    v := vinf;
    for x := 0 to 5 do
      for y := 0 to 2 do
      begin
        Result[(width - 11) + y][x] := $88 or (v and 1);
        v := v shr 1;
      end;
    v := vinf;
    for y := 0 to 5 do
      for x := 0 to 2 do
      begin
        Result[y][x + (width - 11)] := $88 or (v and 1);
        v := v shr 1;
      end;
  end;
  Result[width - 8][8] := $81;
end;

function getVersionPattern(Version: Integer): Integer;
const
  versionPattern: array [0 .. 33] of Integer = (
    $07C94, $085BC, $09A99, $0A4D3,
    $0BBF6, $0C762, $0D847, $0E60D,
    $0F928, $10B78, $1145D, $12A17,
    $13532, $149A6, $15683, $168C9,
    $177EC, $18EC4, $191E1, $1AFAB,
    $1B08E, $1CC1A, $1D33F, $1ED75,
    $1F250, $209D5, $216F0, $228BA,
    $2379F, $24B0B, $2542E, $26A64,
    $27541, $28C69);
begin
  Result := 0;
  if Version in [7 .. 40] then
    Result := versionPattern[Version - 7];
end;

function getFormatInfo(mask, Level: Integer): word;
const
  formatInfo: array [0 .. 3, 0 .. 7] of word = (
    ($77C4, $72F3, $7DAA, $789D, $662F, $6318, $6C41, $6976),
    ($5412, $5125, $5E7C, $5B4B, $45F9, $40CE, $4F97, $4AA0),
    ($355F, $3068, $3F31, $3A06, $24B4, $2183, $2EDA, $2BED),
    ($1689, $13BE, $1CE7, $19D0, $0762, $0255, $0D0C, $083B));
begin
  Result := 0;
  if (mask < 0) or (mask > 7) or (Level < 0) or (Level > 3) then
    Exit;
  Result := formatInfo[Level][mask];
end;

function getEccLength(Version, Level: Integer): Integer;
const
  ecs: array [0 .. 40, 0 .. 3] of Integer = ((0, 0, 0, 0), (7, 10, 13, 17), // 1
    (10, 16, 22, 28), (15, 26, 36, 44), (20, 36, 52, 64), (26, 48, 72, 88), // 5
    (36, 64, 96, 112), (40, 72, 108, 130), (48, 88, 132, 156),
    (60, 110, 160, 192), (72, 130, 192, 224), // 10
    (80, 150, 224, 264), (96, 176, 260, 308), (104, 198, 288, 352),
    (120, 216, 320, 384), (132, 240, 360, 432), // 15
    (144, 280, 408, 480), (168, 308, 448, 532), (180, 338, 504, 588),
    (196, 364, 546, 650), (224, 416, 600, 700), // 20
    (224, 442, 644, 750), (252, 476, 690, 816), (270, 504, 750, 900),
    (300, 560, 810, 960), (312, 588, 870, 1050), // 25
    (336, 644, 952, 1110), (360, 700, 1020, 1200), (390, 728, 1050, 1260),
    (420, 784, 1140, 1350), (450, 812, 1200, 1440), // 30
    (480, 868, 1290, 1530), (510, 924, 1350, 1620), (540, 980, 1440, 1710),
    (570, 1036, 1530, 1800), (570, 1064, 1590, 1890), // 35
    (600, 1120, 1680, 1980), (630, 1204, 1770, 2100), (660, 1260, 1860, 2220),
    (720, 1316, 1950, 2310), (750, 1372, 2040, 2430) // 40
    );
begin
  Result := ecs[Version][Level];
end;

function getDataLength(Version, Level: Integer): Integer;
const
  words: array [0 .. 40] of Integer = (
    0   , 26  , 44  , 70  , 100 , 134 , 172 , 196 , 242 ,
    292 , 346 , 404 , 466 , 532 , 581 , 655 , 733 , 815 , 901 , 991 , 1085, 1156, 1258,
    1364, 1474, 1588, 1706, 1828, 1921, 2051, 2185, 2323, 2465, 2611, 2761,
    2876, 3034, 3196, 3362, 3532, 3706);
  ecs: array [0 .. 40, 0 .. 3] of Integer = (
    (0  , 0   , 0   , 0  ),
    (7  , 10  , 13  , 17 ), // 1
    (10 , 16  , 22  , 28 ),
    (15 , 26  , 36  , 44 ),
    (20 , 36  , 52  , 64 ),
    (26 , 48  , 72  , 88 ), // 5
    (36 , 64  , 96  , 112 ),
    (40 , 72  , 108 , 130 ),
    (48 , 88  , 132 , 156 ),
    (60 , 110 , 160 , 192 ),
    (72 , 130 , 192 , 224 ), // 10
    (80 , 150 , 224 , 264 ),
    (96 , 176 , 260 , 308 ),
    (104, 198 , 288 , 352 ),
    (120, 216 , 320 , 384 ),
    (132, 240 , 360 , 432 ), // 15
    (144, 280 , 408 , 480 ),
    (168, 308 , 448 , 532 ),
    (180, 338 , 504 , 588 ),
    (196, 364 , 546 , 650 ),
    (224, 416 , 600 , 700 ), // 20
    (224, 442 , 644 , 750 ),
    (252, 476 , 690 , 816 ),
    (270, 504 , 750 , 900 ),
    (300, 560 , 810 , 960 ),
    (312, 588 , 870 , 1050), // 25
    (336, 644 , 952 , 1110),
    (360, 700 , 1020, 1200),
    (390, 728 , 1050, 1260),
    (420, 784 , 1140, 1350),
    (450, 812 , 1200, 1440), // 30
    (480, 868 , 1290, 1530),
    (510, 924 , 1350, 1620),
    (540, 980 , 1440, 1710),
    (570, 1036, 1530, 1800),
    (570, 1064, 1590, 1890), // 35
    (600, 1120, 1680, 1980),
    (630, 1204, 1770, 2100),
    (660, 1260, 1860, 2220),
    (720, 1316, 1950, 2310),
    (750, 1372, 2040, 2430) // 40
    );
begin
  Result := words[Version] - getEccLength(Version, Level);
end;

function getEccSpec(Version, Level: Integer): TEccSpec;
const
  eccTable: array [0 .. 40, 0 .. 3, 0 .. 1] of Byte =
    (((0 , 0 ), (0 , 0 ), (0 , 0 ), (0 , 0 )),
     ((1 , 0 ), (1 , 0 ), (1 , 0 ), (1 , 0 )), // 1
     ((1 , 0 ), (1 , 0 ), (1 , 0 ), (1 , 0 )),
     ((1 , 0 ), (1 , 0 ), (2 , 0 ), (2 , 0 )),
     ((1 , 0 ), (2 , 0 ), (2 , 0 ), (4 , 0 )),
     ((1 , 0 ), (2 , 0 ), (2 , 2 ), (2 , 2 )), // 5
     ((2 , 0 ), (4 , 0 ), (4 , 0 ), (4 , 0 )),
     ((2 , 0 ), (4 , 0 ), (2 , 4 ), (4 , 1 )),
     ((2 , 0 ), (2 , 2 ), (4 , 2 ), (4 , 2 )),
     ((2 , 0 ), (3 , 2 ), (4 , 4 ), (4 , 4 )),
     ((2 , 2 ), (4 , 1 ), (6 , 2 ), (6 , 2 )), // 10
     ((4 , 0 ), (1 , 4 ), (4 , 4 ), (3 , 8 )),
     ((2 , 2 ), (6 , 2 ), (4 , 6 ), (7 , 4 )),
     ((4 , 0 ), (8 , 1 ), (8 , 4 ), (12, 4 )),
     ((3 , 1 ), (4 , 5 ), (11, 5 ), (11, 5 )),
     ((5 , 1 ), (5 , 5 ), (5 , 7 ), (11, 7 )), // 15
     ((5 , 1 ), (7 , 3 ), (15, 2 ), (3 , 13)),
     ((1 , 5 ), (10, 1 ), (1 , 15), (2 , 17)),
     ((5 , 1 ), (9 , 4 ), (17, 1 ), (2 , 19)),
     ((3 , 4 ), (3 , 11), (17, 4 ), (9 , 16)),
     ((3 , 5 ), (3 , 13), (15, 5 ), (15, 10)), // 20
     ((4 , 4 ), (17, 0 ), (17, 6 ), (19, 6)),
     ((2 , 7 ), (17, 0 ), (7 , 16), (34, 0)),
     ((4 , 5 ), (4 , 14), (11, 14), (16, 14)),
     ((6 , 4 ), (6 , 14), (11, 16), (30, 2)),
     ((8 , 4 ), (8 , 13), (7 , 22), (22, 13)), // 25
     ((10, 2 ), (19, 4 ), (28, 6 ), (33, 4)),
     ((8 , 4 ), (22, 3 ), (8 , 26), (12, 28)),
     ((3 , 10), (3 , 23), (4 , 31), (11, 31)),
     ((7 , 7 ), (21, 7 ), (1 , 37), (19, 26)),
     ((5 , 10), (19, 10), (15, 25), (23, 25)), // 30
     ((13, 3 ), (2 , 29), (42, 1 ), (23, 28)),
     ((17, 0 ), (10, 23), (10, 35), (19, 35)),
     ((17, 1 ), (14, 21), (29, 19), (11, 46)),
     ((13, 6 ), (14, 23), (44, 7 ), (59, 1)),
     ((12, 7 ), (12, 26), (39, 14), (22, 41)), // 35
     ((6 , 14), (6 , 34), (46, 10), (2 , 64)),
     ((17, 4 ), (29, 14), (49, 10), (24, 46)),
     ((4 , 18), (13, 32), (48, 14), (42, 32)),
     ((20, 4 ), (40, 7 ), (43, 22), (10, 67)),
     ((19, 6 ), (18, 31), (34, 34), (20, 61)) // 40
    );
begin
  FillChar(Result[0], sizeof(Result), 0);
  Result[0] := eccTable[Version][Level][0];
  Result[3] := eccTable[Version][Level][1];
  Result[1] := getDataLength(Version, Level) div (Result[0] + Result[3]);
  Result[2] := getEccLength(Version, Level) div (Result[0] + Result[3]);
  Result[4] := 0;
  if Result[3] <> 0 then
    Result[4] := Result[1] + 1;
end;

function getMinimumVersion(Size, Level: Integer): Integer;
var
  i: Integer;
begin
  for i := 1 to QRSPEC_VERSION_MAX do
    if getDataLength(i, Level) >= Size then begin
      result:= i;
    Exit;
    end;
    //  Exit(i);
  Result := -1;
end;

function maximumWords(mode, Version: Integer): Integer;
const
  lengthTableBits: array [0 .. 3, 0 .. 2] of Integer = (
    (10, 12, 14), (9, 11, 13), (8, 16, 16), (8, 10, 12));
var
  l: Integer;
  bits: Integer;
begin
  if Version <= 9 then
    l := 0
  else
  if Version <= 26 then
    l := 1
  else
    l := 2;
  bits := lengthTableBits[mode][l];
  Result := (1 shl bits) - 1;
  if mode = QR_MODE_KANJI then
    Result := Result * 2;
end;

procedure StrSet(var srctab: TQRFrame; x, y: Integer; repl: string;
  replLen: Integer = -1);
var
  i: Integer;
begin
  if replLen <> -1 then
    repl := copy(repl, 1, replLen)
  else
    replLen := Length(repl);

  for i := 1 to replLen do
    srctab[y][x+i-1] := Byte(repl[i]);
end;

function mask0(x, y: Integer): Byte;
begin
  Result := (x + y) and 1;
end;

function mask1(x, y: Integer): Byte;
begin
  Result := y and 1;
end;

function mask2(x, y: Integer): Byte;
begin
  Result := x mod 3;
end;

function mask3(x, y: Integer): Byte;
begin
  Result := (x + y) mod 3;
end;

function mask4(x, y: Integer): Byte;
begin
  Result := ((y div 2) + (x div 3)) and 1;
end;

function mask5(x, y: Integer): Byte;
begin
  Result := ((x * y) and 1) + (x * y) mod 3;
end;

function mask6(x, y: Integer): Byte;
begin
  Result := (((x * y) and 1) + (x * y) mod 3) and 1;
end;

function mask7(x, y: Integer): Byte;
begin
  Result := (((x * y) mod 3) + ((x * y) and 1)) and 1;
end;

function MakeQRMask(const AWidth: Integer; const AFrame: TQRFrame;
  const AMask, ALevel: Integer): TQRMask;
type
  TMaskFunc = function(x, y: Integer): Byte;

const masks: array [0 .. 7] of
  TMaskFunc = (mask0, mask1, mask2, mask3, mask4, mask5, mask6, mask7);

var
  i: Integer;
  x, y: Integer;
  bitMask: TQRMask;
  format: Integer;
  v: Byte;
begin
  SetLength(Result, AWidth);
  for i := 0 to AWidth - 1 do
  begin
    SetLength(Result[i], AWidth);
    FillChar(Result[i][0], AWidth, 0);
  end;

  SetLength(bitMask, AWidth);
  for y := 0 to AWidth - 1 do
  begin
    SetLength(bitMask[y], AWidth);
    FillChar(bitMask[y][0], AWidth, 0);
  end;

  for y := 0 to AWidth - 1 do
    for x := 0 to AWidth - 1 do
      if AFrame[y][x] and $80 = $80 then
        bitMask[y][x] := 0
      else
        bitMask[y][x] := IfThen(masks[AMask](x, y) = 0, 1, 0);

  for y := 0 to AWidth - 1 do
    for x := 0 to AWidth - 1 do
    begin
      if bitMask[y][x] = 1 then
        Result[y][x] := AFrame[y][x] xor bitMask[y][x]
      else
        Result[y][x] := AFrame[y][x];
    end;

  format := getFormatInfo(AMask, ALevel);
  for i := 0 to 7 do
  begin
    v := $84 + (format and 1);
    AFrame[8][AWidth - 1 - i] := v;
    if i < 6 then
      AFrame[i][8] := v
    else
      AFrame[i + 1][8] := v;
    format := format shr 1;
  end;

  for i := 0 to 6 do
  begin
    v := $84 + (format and 1);
    AFrame[AWidth - 7 + i][8] := v;
    if i = 0 then
      AFrame[8][7] := v
    else
      AFrame[8][6 - i] := v;
    format := format shr 1;
  end;
end;

end.
