////////////////////////////////////////////////////////////////////////////////
//
// JPEGLoader.pas - JPEG wrapper
// -----------------------------
// Version:   2005-10-02
// Maintain:  Michael Vinther    |    mv@logicnet·dk
//
// Last changes:
//
unit JPEGLoader;

interface

uses SysUtils, LinarBitmap, Streams, Windows, Graphics, DelphiStream, JPEG, MemStream,
  Classes, Monitor, BitmapConversion;

resourcestring
  rsJPEGImageFile = 'Joint Picture Expert Group';

const
  DefaultSize : TPoint = (X:MaxInt;Y:MaxInt);

type
  TJPEGLoader = class(TBitmapLoader)
    public
      Quality       : Integer; // Image quality, 1=worst, 100=best
      FileSizeLimit : Integer; // If FileSizeLimit>0, SaveToStream will try to limit the file size
                               // to FileSizeLimit bytes.
      DesiredSize   : TPoint;  // LoadFromStream can save time by decoding an image of only this size
      TrueSize      : TPoint;  // Actual size of last image loaded

      constructor Create;

      function CanLoad(const Ext: string): Boolean; override;
      function CanSave(const Ext: string): Boolean; override;

      function GetLoadFilter: string; override;
      function GetSaveFilter: string; override;

      procedure LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap); override;
      procedure SaveToStream(Stream: TSeekableStream; const Ext: string; LBitmap: TLinarBitmap); override;
    end;

var
  Default : TJPEGLoader;

implementation

constructor TJPEGLoader.Create;
begin
  inherited;
  DesiredSize:=DefaultSize;
end;

function TJPEGLoader.GetLoadFilter: string;
begin
  Result:=rsJPEGImageFile+' (*.jpg,*.jpeg,*.jpe)|*.jpg;*.jpeg;*.jpe';
end;

function TJPEGLoader.GetSaveFilter: string;
begin
  Result:=rsJPEGImageFile+' (*.jpg)|*.jpg';
end;

function TJPEGLoader.CanLoad(const Ext: string): Boolean;
begin
  Result:=(Ext='JPG') or (Ext='JPEG') or (Ext='JPE');
end;

function TJPEGLoader.CanSave(const Ext: string): Boolean;
begin
  Result:=(Ext='JPG') or (Ext='JPEG');
end;

procedure TJPEGLoader.LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap);
var
  JPEG : TJPEGImage;
  DelphiStream : TSeekableDelphiStream;
begin
  JPEG:=TJPEGImage.Create;
  try
    DelphiStream:=TSeekableDelphiStream.Create(Stream);
    try
      JPEG.LoadFromStream(DelphiStream);
    finally
      DelphiStream.Free;
    end;
    JPEG.Performance:=jpBestQuality;
    JPEG.Scale:=jsFullSize;
    TrueSize:=Point(JPEG.Width,JPEG.Height);
    while (JPEG.Scale<jsEighth) and (JPEG.Width div 2>=DesiredSize.X) and (JPEG.Height div 2>=DesiredSize.Y) do
      JPEG.Scale:=Succ(JPEG.Scale);
    JPEG.PixelFormat:=jf24bit;
    Bitmap.Assign(JPEG);
    if not Bitmap.Present then raise ELinearBitmap.Create(rsErrorInBitmapData);
    if JPEG.GrayScale then ConvertToGrayscale(Bitmap)
    else if Bitmap.PixelFormat=pf32bit then Bitmap.PixelFormat:=pf24bit;
  finally
    JPEG.Free;
  end;
end;

procedure TJPEGLoader.SaveToStream(Stream: TSeekableStream; const Ext: string; LBitmap: TLinarBitmap);
var
  X, Y : Integer;
  Bitmap : TBitmap;
  JPEG : TJPEGImage;
  OutPix : ^RGBRec;
  Pix : ^Byte;
  DelphiStream : TSeekableDelphiStream;
  MemStream : TMemoryStream;
  MinAboveSizeQuality, MaxBelowSizeQuality, CurrentSize, QualityGuess : Integer;
begin
  Bitmap:=TBitmap.Create;
  try
    if LBitmap.Pixelformat=pf24bit then LBitmap.AssignTo(Bitmap)
    else if LBitmap.Pixelformat=pf8bit then
    begin
      Bitmap.PixelFormat:=pf24bit;
      Bitmap.Width:=LBitmap.Width;
      Bitmap.Height:=LBitmap.Height;
      for Y:=0 to LBitmap.Height-1 do
      begin
       Pix:=@LBitmap.ScanLine[Y]^;
       OutPix:=@Bitmap.ScanLine[Y]^;
       for X:=0 to LBitmap.Width-1 do
       begin
        OutPix^:=LBitmap.Palette^[Pix^];
        Inc(Pix); Inc(OutPix);
       end;
      end;
    end;

    JPEG:=TJPEGImage.Create;
    try
      JPEG.Scale:=jsFullSize;
      JPEG.PixelFormat:=jf24bit;
      if LBitmap.IsGrayscale then JPEG.GrayScale:=True;

      if FileSizeLimit>0 then // Optimize file size to FileSizeLimit
      begin
        if Quality<1 then Quality:=JPEG.CompressionQuality;
        QualityGuess:=Quality;
        MinAboveSizeQuality:=Quality+1;
        MaxBelowSizeQuality:=1;
        MemStream:=TMemoryStream.Create;
        try
          repeat
            MemStream.Position:=0;
            JPEG.CompressionQuality:=QualityGuess;
            JPEG.Assign(Bitmap);
            JPEG.SaveToStream(MemStream);
            CurrentSize:=MemStream.Position;
            if CurrentSize>FileSizeLimit then
            begin
              MinAboveSizeQuality:=QualityGuess;
              if QualityGuess<=1 then Break;
            end
            else if CurrentSize<FileSizeLimit then
            begin
              MaxBelowSizeQuality:=QualityGuess;
              if (QualityGuess>=100) or (MaxBelowSizeQuality+1=MinAboveSizeQuality) then Break;
            end
            else Break; // CurrentSize=FileSizeLimit
            QualityGuess:=(MinAboveSizeQuality+MaxBelowSizeQuality) div 2;
          until False;

          Stream.Write(MemStream.Memory^,CurrentSize);
        finally
          MemStream.Free;
        end;
      end
      else // Use specified quality
      begin
        if Quality>=1 then JPEG.CompressionQuality:=Quality;
        JPEG.Assign(Bitmap);
        DelphiStream:=TSeekableDelphiStream.Create(Stream);
        try
          JPEG.SaveToStream(DelphiStream);
        finally
          DelphiStream.Free;
        end;
      end;
    finally
      JPEG.Free;
    end;
  finally
    Bitmap.Free;
  end;
end;

initialization
  Default:=TJPEGLoader.Create;
  LinarBitmap.AddLoader(Default);
finalization
  Default.Free;
end.

