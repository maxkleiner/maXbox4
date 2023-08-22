unit DPUtils;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Jpeg, Math;

type
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..0] of TRGBTriple;

  TThumbData = class(TObject)
  public
    Caption: string;
    Bitmap: TBitmap;

    constructor Create(ACaption: string; ABitmap: TBitmap);
  end;

const
  PIC_BMP = 0;
  PIC_JPG = 1;

  THUMB_WIDTH  = 60;
  THUMB_HEIGHT = 60;

function IsEqualFile(Filename: string; Size: Integer; LastWriteTime: TDateTime): Boolean;
procedure GetFileInfo(Filename: string; var Size: Integer; var LastWriteTime: TDateTime);

function ReadBitmap(Filehandle: Integer; Width, Height: Integer): TBitmap;
procedure WriteBitmap(Filehandle: Integer; bmp: TBitmap);

function OpenPicture(fn: string; var tp: Integer): Integer;
function ConvertPicture(pi: Integer; tp: Integer): TBitmap;

function LoadPicture(fn: string; var w, h: Integer): TBitmap;

function TurnBitmap(bmp: TBitmap; ang: Integer): TBitmap;

function RotateBitmap(Bitmap: TBitmap; Direction: Integer): TBitmap;
function StretchBitmap(Canvas: TCanvas; re: TRect; bmp: TBitmap): TRect;
function ThumbBitmap(Bitmap: TBitmap; Width, Height: Integer): TBitmap;

procedure ClearFrame(Canvas: TCanvas; Rect: TRect; Width, Height: Integer);

procedure FindFiles(path, mask: string; items: TStringList);
function FileName(s: string): string;
function ParentPath(path: string): string;

function AddBackSlash(path: string): string;
function CutBackSlash(path: string): string;

implementation

uses DPFile;

constructor TThumbData.Create(ACaption: string; ABitmap: TBitmap);
begin
  Caption:=ACaption;
  Bitmap:=ABitmap;
end;

//

function IsEqualFile(Filename: string; Size: Integer; LastWriteTime: TDateTime): Boolean;
var Filehandle: Integer;

begin
  MakeFileOpen(Filename, Filehandle);
  result:=(GetFileSize(Filehandle)=Size) and (GetFileTimes(Filehandle).LastWriteTime=LastWriteTime);
  MakeFileClose(Filehandle);
end;

procedure GetFileInfo(Filename: string; var Size: Integer; var LastWriteTime: TDateTime);
var Filehandle: Integer;

begin
  MakeFileOpen(Filename, Filehandle);
  Size:=GetFileSize(Filehandle);
  LastWriteTime:=GetFileTimes(Filehandle).LastWriteTime;
  MakeFileClose(Filehandle);
end;

//

function ReadBitmap(Filehandle: Integer; Width, Height: Integer): TBitmap;
var i: Integer;

    Row: pRGBTripleArray;
   
begin
  result:=TBitmap.Create;
  result.PixelFormat:=pf24bit;
  result.Width:=Width;
  result.Height:=Height;

  for i:=0 to result.Height-1 do
  begin
    Row:=result.Scanline[i];
   
    MakeFileRead(Filehandle, Row[0], result.Width*sizeof(TRGBTriple));
  end;
end;

procedure WriteBitmap(Filehandle: Integer; bmp: TBitmap);
var i: Integer;

    Row: pRGBTripleArray;

begin
  bmp.PixelFormat:=pf24bit;

  for i:=0 to bmp.Height-1 do
  begin
    Row:=bmp.Scanline[i];

    MakeFileWrite(Filehandle, Row[0], bmp.Width*sizeof(TRGBTriple));
  end;
end;

//

function OpenBmp(fn: string; var tp: Integer): TBitmap;
begin
  result:=nil; tp:=-1;

  if not FileExists(fn) then
    Exit;

  result:=TBitmap.Create;
  result.LoadFromFile(fn);
  tp:=PIC_BMP;
end;

function OpenJpeg(fn: string; var tp: Integer): TJPEGImage;
begin
  result:=nil; tp:=-1;

  if not FileExists(fn) then
    Exit;

  result:=TJPEGImage.Create;
  result.LoadFromFile(fn);
  tp:=PIC_JPG;
end;

function OpenPicture(fn: string; var tp: Integer): Integer;
var s: string;

begin
  result:=0; tp:=-1;

  if not FileExists(fn) then
    Exit;

  s:=AnsiUpperCase(ExtractFileExt(fn));

  if (s='.JPEG') or (s='.JPG') then
    result:=Integer(OpenJpeg(fn, tp));
  if s='.BMP' then
    result:=Integer(OpenBmp(fn, tp));
end;

//

function ConvertPicture(pi: Integer; tp: Integer): TBitmap;
var jpg: TJPEGImage;

begin
  result:=nil;
  
  case tp of
    PIC_BMP: begin
               result:=TBitmap(pi);
             end;

    PIC_JPG: begin
               jpg:=TJPEGImage(pi);

               result:=TBitmap.Create;
               result.Assign(jpg);

               jpg.Free;
             end;
  end;
end;

//

function LoadBmp(fn: string): TBitmap;
begin
  if not FileExists(fn) then
  begin
    result:=nil;
    Exit;
  end;

  result:=TBitmap.Create;
  result.LoadFromFile(fn);
end;

function LoadJpeg(fn: string): TBitmap;
var jpg: TJPEGImage;

begin
  if not FileExists(fn) then
  begin
    result:=nil;
    Exit;
  end;

  jpg:=TJPEGImage.Create;
  jpg.LoadFromFile(fn);

  result:=TBitmap.Create;

  case jpg.PixelFormat of
    jf24Bit: result.PixelFormat:=pf24bit;
     jf8Bit: result.PixelFormat:=pf8bit;
  else
    result.PixelFormat:=pf32bit;
  end;

  result.Width:=jpg.Width;
  result.Height:=jpg.Height;

  jpg.DIBNeeded;

  result.Canvas.Draw(0, 0, jpg);

  jpg.Free;
end;

function LoadPicture(fn: string; var w, h: Integer): TBitmap;
var s: string;

begin
  if not FileExists(fn) then
  begin
    result:=nil;
    Exit;
  end;

  s:=AnsiUpperCase(ExtractFileExt(fn));

  if (s='.JPEG') or (s='.JPG') then
    result:=LoadJpeg(fn);
  if s='.BMP' then
    result:=LoadBmp(fn);

  w:=result.Width;
  h:=result.Height;
end;

//

function TurnBitmap(bmp: TBitmap; ang: Integer): TBitmap;
begin
  if bmp.PixelFormat<>pf24bit then
    bmp.PixelFormat:=pf24bit;

  result:=RotateBitmap(bmp, ang);
end;

//

function RotateBitmap(Bitmap: TBitmap; Direction: Integer): TBitmap;
var i, j: Integer;

    RowOrg: pRGBTripleArray;
    RowRot: pRGBTRipleArray;

begin
  result:=TBitmap.Create;
  result.Width:=Bitmap.Height;
  result.Height:=Bitmap.Width;
  result.PixelFormat:=pf24bit;

  if Direction>0 then
    for j:=0 to Bitmap.Height-1 do
    begin
       RowOrg:=Bitmap.Scanline[j];

       for i:=0 to Bitmap.Width-1 do
       begin
         RowRot:=result.Scanline[i];

         RowRot[Bitmap.Height-1-j]:=RowOrg[i];
       end;
    end
  else
    for j:=0 to Bitmap.Height-1 do
    begin
       RowOrg:=Bitmap.Scanline[j];

       for i:=0 to Bitmap.Width-1 do
       begin
         RowRot:=result.Scanline[Bitmap.Width-1-i];

         RowRot[j]:=RowOrg[i];
       end;
    end;  
end;

function StretchBitmap(Canvas: TCanvas; re: TRect; bmp: TBitmap): TRect;
var w, h, bw, bh: Integer;
    bv: Extended;

begin
  w:=re.Right-re.Left;
  h:=re.Bottom-re.Top;

  if (bmp.Width<=w) and (bmp.Height<=h) then
  begin
    Canvas.Draw(re.Left+(w-bmp.Width) div 2, re.Top+(h-bmp.Height) div 2, bmp);
    result:=Rect(re.Left+(w-bmp.Width) div 2, re.Top+(h-bmp.Height) div 2, re.Left+(w-bmp.Width) div 2 + bmp.Width, re.Top+(h-bmp.Height) div 2 + bmp.Height);
  end
  else
  begin
    bv:=bmp.Width/bmp.Height;

    if w/bv<=h then
    begin
      bw:=w;
      bh:=Round(w/bv);
    end
    else
    begin
      bw:=Round(h*bv);
      bh:=h;
    end;

    Canvas.StretchDraw(Rect(re.Left+(w-bw) div 2, re.Top+(h-bh) div 2, re.Left+(w-bw) div 2 + bw, re.Top+(h-bh) div 2 + bh), bmp);
    result:=Rect(re.Left+(w-bw) div 2, re.Top+(h-bh) div 2, re.Left+(w-bw) div 2 + bw, re.Top+(h-bh) div 2 + bh);
  end;
end;

function ThumbBitmap(Bitmap: TBitmap; Width, Height: Integer): TBitmap;
begin
  result:=TBitmap.Create;
  result.PixelFormat:=pf24bit;
  result.Width:=Width;
  result.Height:=Height;

  if Bitmap<>nil then
    StretchBitmap(result.Canvas, Rect(5, 5, Width-5, Height-5), Bitmap);

  with result.Canvas do
  begin
    Brush.Style:=bsClear;
    Pen.Color:=clBlack;
    Rectangle(0, 0, Width, Height);
  end;

  if Bitmap<>nil then
    Bitmap.Free;
end;

//

procedure ClearFrame(Canvas: TCanvas; Rect: TRect; Width, Height: Integer);
begin
  with Canvas do
  begin
    FillRect(Classes.Rect(0, 0, Width, Rect.Top));
    FillRect(Classes.Rect(Rect.Right, Rect.Top, Width, Rect.Bottom));
    FillRect(Classes.Rect(0, Rect.Bottom, Width, Height));
    FillRect(Classes.Rect(0, Rect.Top, Rect.Left, Rect.Bottom));
  end;
end;

//

function InStr(p: Integer; s, ts: string): LongInt;
var i: Integer;

begin
  i:=Pos(ts, Copy(s, p, Length(s)-p+1));

  if i>0 then
    result:=p-1+i
  else
    result:=0;
end;

function DownInStr(p: Integer; s, ts: string): LongInt;
var i, j: Integer;

begin
  i:=0; j:=InStr(i+1, s, ts);

  while (j>0) and (j<=p) do
  begin
    i:=j; j:=InStr(i+1, s, ts);
  end;

  result:=i;
end;

//

procedure FindFiles(path, mask: string; items: TStringList);
var Search: TSearchRec;

begin
  items.Clear;

  path:=AddBackSlash(path);

  if (mask<>'*.*') and (Copy(mask, Length(mask), 1)<>';') then
    mask:=mask+';';

  if FindFirst(path+'*.*', $23, Search)=0 then
     repeat
        if (mask='*.*') or (Pos(AnsiUpperCase(ExtractFileExt(Search.Name)), AnsiUpperCase(mask))>0) then
          items.Add(path+Search.Name);
     until FindNext(Search)<>0;

  FindClose(Search);
end;

function FileName(s: string): string;
var i, j: Integer;

begin
  i:=DownInStr(Length(s), s, '.');
  j:=DownInStr(Length(s), s, ' (');

  if (i>0) and (i<j) then
    result:=Copy(s, 1, j-1)
  else
    result:=s;
end;

function ParentPath(path: string): string;
var i: Integer;

begin
  if ((Copy(path, 2, 2)<>':\') and (Length(path)=3)) or ((Copy(path, 1, 2)<>'\\') and (Length(path)=2)) then
  begin
    result:=path;
    Exit;
  end;

  result:=CutBackSlash(path);

  i:=DownInStr(Length(result), result, '\');

  if i>0 then
    result:=Copy(result, 1, i)
  else
    result:='';
end;

function AddBackSlash(path: string): string;
begin
  if Copy(path, Length(path), 1)<>'\' then
    result:=path+'\'
  else
    result:=path;
end;

function CutBackSlash(path: string): string;
begin
  if ((Length(path)=3) and (Copy(path, 2, 2)=':\')) or ((Length(path)=2) and (Copy(path, 1, 2)='\\')) then
    result:=path
  else
    if (Copy(path, Length(path), 1)='\') then
      result:=Copy(path, 1, Length(path)-1)
    else
      result:=path;
end;

end.
