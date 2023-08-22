/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// GIFLoader.pas - TBitmapLoader wrapper for TGIFImage by Anders Melander
// ----------------------------------------------------------------------
// Version:   2003-01-30
// Maintain:  Michael Vinther    |     mv@logicnet·dk
//
// Last changes:
//   TransparentColor for loading images
//
unit GIFLoader;

interface

uses SysUtils, LinarBitmap, Streams, Graphics, DelphiStream, GIFImg;

resourcestring
  rsGIFImageFile = 'Graphics Interchange Format';

type
  TGIFLoader = class(TBitmapLoader)
                 public
                   TransparentColor : TColor; // Only for reading, -1 if not transparent

                   constructor Create;
                   function CanLoad(const Ext: string): Boolean; override;
                   function CanSave(const Ext: string): Boolean; override;
                   function GetLoadFilter: string; override;
                   procedure LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap); override;
                   procedure SaveToStream(Stream: TSeekableStream; const Ext: string; LBitmap: TLinarBitmap); override;
                 end;

var
  Default : TGIFLoader;

implementation

constructor TGIFLoader.Create;
begin
  inherited Create;
  TransparentColor:=-1;
end;

function TGIFLoader.GetLoadFilter: string;
begin
  Result:=rsGIFImageFile+' (*.gif)|*.gif';
end;

function TGIFLoader.CanLoad(const Ext: string): Boolean;
begin
  Result:=Ext='GIF';
end;

function TGIFLoader.CanSave(const Ext: string): Boolean;
begin
  Result:=Ext='GIF';
end;

procedure TGIFLoader.LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap);
var
  GIF : TGifImage;
  DelphiStream : TSeekableDelphiStream;
begin
  GIF:=TGIFImage.Create;
  try
    DelphiStream:=TSeekableDelphiStream.Create(Stream);
    try
      GIF.LoadFromStream(DelphiStream);
    finally
      DelphiStream.Free;
    end;
    if GIF.IsTransparent then TransparentColor:=GIF.Images[0].Bitmap.TransparentColor
    else TransparentColor:=-1;
    Bitmap.Assign(GIF);
  finally
    GIF.Free;
  end;
end;

procedure TGIFLoader.SaveToStream(Stream: TSeekableStream; const Ext: string; LBitmap: TLinarBitmap);
var
  Bitmap, TempBitmap : TBitmap;
  GIF : TGifImage;
  DelphiStream : TSeekableDelphiStream;
  C, ColorsUsed : Integer;
begin
  Bitmap:=TBitmap.Create;
  try
    Bitmap.PixelFormat:=LBitmap.PixelFormat;
    if LBitmap.PixelFormat=pf24bit then
    begin
      GIFImageDefaultColorReductionBits:=8;
      GIFImageDefaultColorReduction:=rmQuantize;
      GIFImageDefaultDitherMode:=dmFloydSteinberg;
    end;
    LBitmap.AssignTo(Bitmap);

    if LBitmap.PixelFormat=pf8bit then
    begin
      ColorsUsed:=2;
      for C:=255 downto 1 do if (LBitmap.Palette^[C].R<>0) or
                                (LBitmap.Palette^[C].G<>0) or
                                (LBitmap.Palette^[C].B<>0) then
      begin
        ColorsUsed:=C+1;
        Break;
      end;
      if ColorsUsed<=16 then
      begin
        TempBitmap:=TBitmap.Create;
        TempBitmap.Width:=Bitmap.Width;
        TempBitmap.Height:=Bitmap.Height;
        if ColorsUsed<=2 then
        begin
          TempBitmap.PixelFormat:=pf1bit;
          TempBitmap.Palette:=MakeHPalette(LBitmap.Palette^,2)
        end
        else if ColorsUsed<=16 then
        begin
          TempBitmap.PixelFormat:=pf4bit;
          TempBitmap.Palette:=MakeHPalette(LBitmap.Palette^,16)
        end;
        TempBitmap.Canvas.Draw(0,0,Bitmap);
        Bitmap.Free;
        Bitmap:=TempBitmap;
      end;
    end;

    GIF:=TGIFImage.Create;
    try
      GIF.Assign(Bitmap);
      Bitmap.Free; Bitmap:=nil;
      DelphiStream:=TSeekableDelphiStream.Create(Stream);
      try
        GIF.SaveToStream(DelphiStream);
      finally
        DelphiStream.Free;
      end;
    finally
      GIF.Free;
    end;
  finally
    Bitmap.Free;
  end;
end;

initialization
  Default:=TGIFLoader.Create;
  LinarBitmap.AddLoader(Default);
  GIFImageDefaultDitherMode:=dmBurkes; // Set default dithering for 24 -> 8 bit conversion
  GIFImageDefaultColorReduction:=rmQuantize;
finalization
  Default.Free;
end.

