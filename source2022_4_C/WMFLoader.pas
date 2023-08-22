///////////////////////////////////////////////////////////////////////////////////////////////
//
// WMFLoader.pas - Load/save Windows WMF and EMF as TLinearBitmap
// --------------------------------------------------------------
// Version:   2002-12-30
// Maintain:  Michael Vinther   |   mv@logicnet·dk
//
// Contains:
//   (TBitmapLoader)
//     TBitmapLoader
//
unit WMFLoader;

interface

implementation

uses Monitor, SysUtils, Windows, Classes, Streams, Graphics, DelphiStream, ColorMapper,
  LinarBitmap;

type
  TWMFLoader = class(TBitmapLoader)
                 function CanLoad(const Ext: string): Boolean; override;
                 function CanSave(const Ext: string): Boolean; override;

                 function GetLoadFilter: string; override;
                 function GetSaveFilter: string; override;

                 procedure LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap); override;
                 procedure SaveToStream(Stream: TSeekableStream; const Ext: string; LBitmap: TLinarBitmap); override;
               end;

procedure MakePaletteImage(Image: TLinarBitmap);
var
 Pix               : ^RGBRec;
 NewPix            : ^Byte;
 OldMap            : PByteArray;
 Dist, BestDist, P : Integer;
 I, Col, Best      : Integer;
 Pal               : TPalette;
 Found             : Boolean;
begin
  if Image.PixelFormat=pf24bit then
  begin
    Col:=-1; Pointer(Pix):=Image.Map;
    for P:=0 to Image.Width*Image.Height-1 do
    begin
      Found:=False;
      for I:=0 to Col do if (Pal[I].R=Pix^.R) and (Pal[I].G=Pix^.G) and (Pal[I].B=Pix^.B) then
      begin
        Found:=True;
        Break;
      end;
      if not Found then
      begin
        if Col<255 then // Tilføj farven til paletten
        begin
          Inc(Col);
          Pal[Col]:=Pix^;
        end
        else Break;
      end;
      Inc(Pix);
    end;
    // Create image with new palette
    Pointer(Pix):=Image.Map;
    OldMap:=Image.Map;
    Image.Map:=nil;
    Image.New(Image.Width,Image.Height,pf8bit);
    Pointer(NewPix):=Image.Map;
    Best:=0;
    for P:=0 to Image.Size-1 do
    begin
      BestDist:=High(Integer);
      for I:=0 to Col do
      begin
        Dist:=Sqr(Pix^.R-Pal[I].R)+Sqr(Pix^.G-Pal[I].G)+Sqr(Pix^.B-Pal[I].B);
        if Dist<BestDist then
        begin
          Best:=I;
          if Dist=0 then Break;
          BestDist:=Dist;
        end;
      end;
      NewPix^:=Best;
      Inc(Pix); Inc(NewPix);
    end;
    FreeMem(OldMap);
    Image.Palette^:=Pal;
  end;
end;

function TWMFLoader.GetLoadFilter: string;
begin
  Result:='Windows metafile (*.wmf,*.emf)|*.wmf;*.emf';
end;

function TWMFLoader.GetSaveFilter: string;
begin
  Result:='Windows metafile (*.wmf)|*.wmf|'+
          'Windows enhanced metafile (*.emf)|*.emf';
end;

function TWMFLoader.CanLoad(const Ext: string): Boolean;
begin
  Result:=(Ext='WMF') or (Ext='EMF');
end;

function TWMFLoader.CanSave(const Ext: string): Boolean;
begin
  Result:=(Ext='WMF') or (Ext='EMF');
end;

procedure TWMFLoader.LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap);
var
  Metafile : TMetafile;
  DelphiStream : TSeekableDelphiStream;
begin
  Metafile:=TMetafile.Create;
  try
    DelphiStream:=TSeekableDelphiStream.Create(Stream);
    try
      Metafile.LoadFromStream(DelphiStream);
    finally
      DelphiStream.Free;
    end;
    Bitmap.Assign(Metafile);
    if CountColorsUsed(Bitmap)<=256 then MakePaletteImage(Bitmap);
  finally
    Metafile.Free;
  end;
end;

procedure TWMFLoader.SaveToStream(Stream: TSeekableStream; const Ext: string; LBitmap: TLinarBitmap);
var
  Metafile : TMetafile;
  Canvas : TMetafileCanvas;
  DelphiStream : TSeekableDelphiStream;
begin
  Metafile:=TMetafile.Create;
  Metafile.Width:=LBitmap.Width;
  Metafile.Height:=LBitmap.Height;
  if LBitmap.PixelFormat=pf8bit then Metafile.Palette:=MakeHPalette(LBitmap.Palette^);
  Canvas:=TMetafileCanvas.Create(Metafile,0);
  try
    SetStretchBltMode(Canvas.Handle,COLORONCOLOR);
    LBitmap.PaintToCanvas(Canvas,Rect(0,0,LBitmap.Width,LBitmap.Height));
  finally
    Canvas.Free;
  end;
  Metafile.Enhanced:=UpCase(Ext[1])='E';
  DelphiStream:=TSeekableDelphiStream.Create(Stream);
  try
    Metafile.SaveToStream(DelphiStream);
  finally
    DelphiStream.Free;
    Metafile.Free;
  end;
end;

var
  Loader : TWMFLoader;

initialization
  Loader:=TWMFLoader.Create;
  LinarBitmap.AddLoader(Loader);
finalization
  Loader.Free;
end.

