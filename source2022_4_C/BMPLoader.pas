////////////////////////////////////////////////////////////////////////////////
//
// BMPLoader.pas - BMP wrapper
// ---------------------------
// Version:   2005-10-03
// Maintain:  Michael Vinther   |    mv@logicnet·dk
//
// Last changes:
//   Fixed bug in Delphi's BMP implementation
//
unit BMPLoader;

interface

uses Classes, Graphics;

resourcestring
  rsWindowsBitmap = 'Windows bitmap';

type
  TVKBitmap =class(TBitmap)
  public
    procedure LoadFromStream(Stream: TStream); override;
  end;

implementation

uses SysUtils, LinarBitmap, Streams, DelphiStream, UniDIB, DIBTools;

//==============================================================================================================================
// TVKBitmap
//==============================================================================================================================
procedure TVKBitmap.LoadFromStream(Stream: TStream);
var
  StartPos : Int64;
  DIB : TUniDIB;
begin
  StartPos:=Stream.Position;
  try
    inherited LoadFromStream(Stream);
    if PixelFormat=pf32bit then Abort; // I don't trust Delphi BMP loader with this format...
  except
    // Bug in Delphi's BMP loader, try Vit Kovalcik's
    Stream.Position:=StartPos;
    DIB:=nil;
    try
      if UDIBLoadBMP(Stream,DIB)<>UDIBNoError then raise Exception.Create(rsUnsupportedFileFormat);
      Width:=Abs(DIB.Width);
      Height:=Abs(DIB.Height);
      DIB.DIBToScreen(Canvas.Handle);
    finally
      DIB.Free;
    end;
  end;
end;

//==============================================================================================================================
// TBMPLoader
//==============================================================================================================================
type
  TBMPLoader = class(TBitmapLoader)
    public
      function CanLoad(const Ext: string): Boolean; override;
      function CanSave(const Ext: string): Boolean; override;

      function GetLoadFilter: string; override;

      procedure LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap); override;
      procedure SaveToStream(Stream: TSeekableStream; const Ext: string; LBitmap: TLinarBitmap); override;
    end;

function TBMPLoader.GetLoadFilter: string;
begin
  Result:=rsWindowsBitmap+' (*.bmp)|*.bmp';
end;

function TBMPLoader.CanLoad(const Ext: string): Boolean;
begin
  Result:=Ext='BMP';
end;

function TBMPLoader.CanSave(const Ext: string): Boolean;
begin
  Result:=Ext='BMP';
end;

procedure TBMPLoader.LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap);
var
  BMP : TVKBitmap;
  DelphiStream : TSeekableDelphiStream;
begin
  BMP:=TVKBitmap.Create;
  try
    DelphiStream:=TSeekableDelphiStream.Create(Stream);
    try
      BMP.LoadFromStream(DelphiStream);
    finally
      DelphiStream.Free;
    end;
    if BMP.Pixelformat in [pf1bit,pf4bit] then BMP.Pixelformat:=pf8bit
    else if BMP.Pixelformat in [pfDevice, pf15bit, pf16bit, pf32bit, pfCustom] then BMP.Pixelformat:=pf24bit;
    Bitmap.Assign(BMP);
  finally
    BMP.Free;
  end;
end;

procedure TBMPLoader.SaveToStream(Stream: TSeekableStream; const Ext: string; LBitmap: TLinarBitmap);
var
  Bitmap : TBitmap;
  DelphiStream : TSeekableDelphiStream;
begin
  Bitmap:=TBitmap.Create;
  try
    LBitmap.AssignTo(Bitmap);
    DelphiStream:=TSeekableDelphiStream.Create(Stream);
    try
      Bitmap.SaveToStream(DelphiStream);
    finally
      DelphiStream.Free;
    end;
  finally
    Bitmap.Free;
  end;
end;

var
  Loader : TBMPLoader;

initialization
  Loader:=TBMPLoader.Create;
  LinarBitmap.AddLoader(Loader);
  TPicture.RegisterFileFormat('bmp',rsWindowsBitmap,TVKBitmap);
finalization
  Loader.Free;
end.

