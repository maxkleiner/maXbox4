unit FileStreamW;

interface

uses
  Classes, Windows, SysUtils;

type
  TFileStreamW = class (TFileStream)
  protected
    FFileName: WideString;         
    FIsReadOnly: Boolean;
  public
    class function LoadUnicodeFrom(const FileName: WideString;
      AsIsAnsi: Boolean = False): WideString;

    constructor Create(const FileName: WideString; Mode: Word);
    // CreateCustom works like Create(fmCreate) but allows more specified access mode
    // (FileCreate always opens new file with exclusive access). Mode supports fmForcePath.
    constructor CreateCustom(const FileName: WideString; Mode: DWord);

    property FileName: WideString read FFileName;
    property IsReadOnly: Boolean read FIsReadOnly;
  end;

const
  fmOpenRead       = SysUtils.fmOpenRead;
  fmOpenWrite      = SysUtils.fmOpenWrite;
  fmOpenReadWrite  = SysUtils.fmOpenReadWrite;

  fmShareCompat    = SysUtils.fmShareCompat;
  fmShareExclusive = SysUtils.fmShareExclusive;
  fmShareDenyWrite = SysUtils.fmShareDenyWrite;
  fmShareDenyRead  = SysUtils.fmShareDenyRead;
  fmShareDenyNone  = SysUtils.fmShareDenyNone;

  fmForcePath      = $80000000;   // TFileStreamW-specific flag used in CreateCustom to ForceDirectories.

{
  This method handles UTF-8/Unicode/Unicode-BE files with signatures treating others as
  using native ANSI charset. If AsIsAnsi = True signatureless files are not converted from
  system codepage to Unicode but simply copied with high-order byte set to 0. This is useful
  if you're planning to manually convert it later and do not want any chars get corrupted.
  Rewinds stream to the beginning. When returns Position = Size.
}
function LoadUnicodeFromStream(S: TStream; AsIsAnsi: Boolean = False): WideString;

implementation

uses UtilsW;

const
  UTF8Signature: array[0..2] of Char              = (#$EF, #$BB, #$BF);
  UnicodeSignature: array[0..1] of Char           = (#$FF, #$FE);
  BigEndianUnicodeSignature: array[0..1] of Char  = (#$FE, #$FF);

// SysUtils.pas: 4788
function FileCreateW(const FileName: WideString; Mode: LongWord; CreationMode: LongWord = CREATE_ALWAYS): Integer;
const
  AccessMode: array[0..2] of LongWord = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of LongWord = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
  Result := Integer(CreateFileW(PWideChar(FileName), AccessMode[Mode and 3],
                    ShareMode[(Mode and $F0) shr 4], NIL, CreationMode, FILE_ATTRIBUTE_NORMAL, 0))
end;

function FileOpenW(const FileName: WideString; Mode: LongWord): Integer;
begin
  Result := FileCreateW(FileName, Mode, OPEN_EXISTING)
end;

function LoadUnicodeFromStream(S: TStream; AsIsAnsi: Boolean = False): WideString;
type
  TEncoding = (eANSI, eUTF8, eUnicode, eUnicodeBE);
const
  EncOffsets: array[TEncoding] of Byte = (0, 0, 2, 2);
var
  Sign: array[0..2] of Char;
  Encoding: TEncoding;
  Data: String;
  I: Integer;
  Temp: Char;
begin
  S.Position := 0;
  S.Read(Sign[0], 3);

  if Sign = UTF8Signature then
    Encoding := eUTF8
    else if Copy(Sign, 1, 2) = UnicodeSignature then
      Encoding := eUnicode
      else if Copy(Sign, 1, 2) = BigEndianUnicodeSignature then
        Encoding := eUnicodeBE
        else
          Encoding := eANSI;

  S.Position := EncOffsets[Encoding];
  SetLength(Data, S.Size - S.Position);
  S.ReadBuffer(Data[1], Length(Data));

  case Encoding of
  eANSI:
    if AsIsAnsi then
    begin
      SetLength(Result, Length(Data));
      for I := 1 to Length(Data) do
        Result[I] := WideChar( Byte(Data[I]) );
    end
      else
        Result := Data;   // Delphi converts strings automatically from system codepage.
  eUTF8:
    Result := UTF8Decode(Data);
  eUnicode, eUnicodeBE:
    begin
      if Encoding = eUnicodeBE then
        for I := 1 to Length(Data) do
          if I mod 2 = 0 then
          begin
            Temp := Data[I - 1];
            Data[I - 1] := Data[I];
            Data[I] := Temp;
          end;

      SetLength(Result, Length(Data) div 2);
      Move(Data[1], Result[1], Length(Data));
    end;
  end;

  S.Position := S.Size;
end;

{ TFileStreamW }

class function TFileStreamW.LoadUnicodeFrom(const FileName: WideString;
  AsIsAnsi: Boolean = False): WideString;
var
  Stream: TFileStreamW;
begin
  Stream := Self.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadUnicodeFromStream(Stream, AsIsAnsi);
  finally
    Stream.Free;
  end;
end;
                
constructor TFileStreamW.Create(const FileName: WideString; Mode: Word);
var
  Error: DWord;
begin
  FFileName := FileName;

  if Mode = fmCreate then
  begin
    inherited Create(FileCreateW(FileName, fmOpenReadWrite or fmShareExclusive));
    if FHandle < 0 then
    begin
      Error := GetLastError;
      raise EFCreateError.CreateFmt('Cannot create file ''%s'' with %s. %s', [ExpandFileName(FileName), ClassName, SysErrorMessage(Error)])
    end;
  end
    else
    begin
      inherited Create(FileOpenW(FileName, Mode));
      FIsReadOnly := (fmOpenReadWrite or fmOpenWrite) and Mode = 0;

      if FHandle < 0 then
      begin
        Error := GetLastError;
        raise EFOpenError.CreateFmt('Cannot open file ''%s'' with %s. %s', [ExpandFileName(FileName), ClassName, SysErrorMessage(Error)])
      end;
    end
end;

constructor TFileStreamW.CreateCustom;
begin
  FFileName := FileName;

  if (Mode = fmCreate) or (Mode and (fmOpenRead or fmOpenWrite or fmOpenReadWrite) <> 0) then
    raise EFCreateError.CreateFmt('%s.CreateCustom implies fmCreate, use Create for other modes.', [ClassName]);

  if Mode and fmForcePath <> 0 then
    ForceDirectories(ExtractFilePath(FileName));

  inherited Create(FileCreateW(FileName, Mode and $FFFF + 2));

  if FHandle < 0 then
    raise EFCreateError.CreateFmt('Cannot create file ''%s'' with %s.CreateCustom. %s', [ExpandFileName(FileName), ClassName, SysErrorMessage(GetLastError)])
end;

end.
