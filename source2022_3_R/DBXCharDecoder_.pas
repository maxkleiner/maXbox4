// DO NOT EDIT THIS FILE - WARNING WARNING - Generated file
unit DBXCharDecoder;
interface
uses
  DBXPlatform,
  SysUtils;
type
  TDBXCharDecoder = class
  public
    procedure InitDecoder;
    function GrowDecodeBufTo(NewSize: Integer): Boolean;
    function Decode(const Buf: TBytes; BufOff: Integer; MaxBytes: Integer): Boolean; virtual;
    procedure AddNullChar;
    destructor Destroy; //override;
 // private
    function DecodeChars(const Buf: TBytes; BufOff: Integer; MaxOff: Integer): Boolean;
  protected
    FHitChar: Boolean;
    FHasHalfChar: Boolean;
    FHalfChar: Byte;
    FDecodeLength: Integer;
    FNullTerminated: Boolean;
    FDecodeOff: Integer;
    FDecodeBuf: TDBXWideChars;
    FAddQuotes: Boolean;
  private
    FPreventGrowth: Boolean;
  public
    property DecodeOff: Integer read FDecodeOff;
    property DecodeBuf: TDBXWideChars read FDecodeBuf;
    property PreventGrowth: Boolean write FPreventGrowth;
  end;

implementation
uses
  DBXPlatformUtil;

procedure TDBXCharDecoder.InitDecoder;
begin
  FDecodeOff := -1;
  FHitChar := False;
  FHasHalfChar := False;
  FAddQuotes := False;
end;

function TDBXCharDecoder.GrowDecodeBufTo(NewSize: Integer): Boolean;
var
  NewDecodeBuf: TDBXWideChars;
begin
  if FPreventGrowth then
    raise Exception.Create('Unexpected growth');
  if NewSize < 1 then
    NewSize := 16;
  if FDecodeLength < NewSize then
  begin
    FDecodeLength := NewSize;
    SetLength(NewDecodeBuf,NewSize);
    if FDecodeBuf <> nil then
      TDBXPlatform.CopyCharArray(FDecodeBuf, 0, NewDecodeBuf, 0, FDecodeOff);
    FDecodeBuf := NewDecodeBuf;
  end;
  Result := True;
end;

function TDBXCharDecoder.Decode(const Buf: TBytes; BufOff: Integer; MaxBytes: Integer): Boolean;
var
  MaxOff: Integer;
  B: Byte;
begin
  MaxOff := BufOff + MaxBytes;
  ;
  if FHitChar then
  begin
    Result := DecodeChars(Buf, BufOff, MaxOff);
    exit;
  end;
  Decr(BufOff);
  while Incr(BufOff) < MaxOff do
  begin
    B := Buf[BufOff];
    if (B = Ord(#$0)) and FNullTerminated then
    begin
      Result := True;
      exit;
    end
    else if B = Byte(255) then
    begin
      FHitChar := True;
      Incr(BufOff);
      begin
        Result := DecodeChars(Buf, BufOff, MaxOff);
        exit;
      end;
    end;
    if Incr(FDecodeOff) >= FDecodeLength then
      if not GrowDecodeBufTo(FDecodeLength * 2) then
      begin
        Result := False;
        exit;
      end;
    FDecodeBuf[FDecodeOff] := WideChar((B and 255));
  end;
  Result := True;
end;

function TDBXCharDecoder.DecodeChars(const Buf: TBytes; BufOff: Integer; MaxOff: Integer): Boolean;
var
  Ch: WideChar;
begin
  ;
  DecrAfter(BufOff);
  MaxOff := MaxOff - 2;
  if FHasHalfChar then
  begin
    Ch := WideChar(((Integer((FHalfChar)) shl 8) or ((Buf[Incr(BufOff)] and 255))));
    if Incr(FDecodeOff) >= FDecodeLength then
      if not GrowDecodeBufTo(FDecodeLength * 2) then
      begin
        Result := False;
        exit;
      end;
    FDecodeBuf[FDecodeOff] := Ch;
    FHasHalfChar := False;
  end;
  while BufOff < MaxOff do
  begin
    Ch := WideChar((((Integer((Buf[Incr(BufOff)] and 255))) shl 8) or (Integer(Buf[Incr(BufOff)]) and 255)));
    if (Ch = #$0) and FNullTerminated then
    begin
      Result := True;
      exit;
    end;
    if Incr(FDecodeOff) >= FDecodeLength then
      if not GrowDecodeBufTo(FDecodeLength * 2) then
      begin
        Result := False;
        exit;
      end;
    FDecodeBuf[FDecodeOff] := Ch;
  end;
  if BufOff = MaxOff then
  begin
    FHalfChar := Buf[Incr(BufOff)];
    FHasHalfChar := True;
  end;
  Result := True;
end;

procedure TDBXCharDecoder.AddNullChar;
begin
  if Incr(FDecodeOff) >= FDecodeLength then
    GrowDecodeBufTo(FDecodeLength + 1);
  FDecodeBuf[FDecodeOff] := WideChar(0);
end;

destructor TDBXCharDecoder.Destroy;
begin
  FDecodeBuf := nil;
  inherited Destroy;
end;

end.
