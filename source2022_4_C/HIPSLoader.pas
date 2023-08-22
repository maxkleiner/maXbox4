////////////////////////////////////////////////////////////////////////////////
//
// HIPSLoader.pas - Reading of HIPS images
// ---------------------------------------
// Version:   2004-01-01
// Maintain:  Michael Vinther    |     mv@logicnet·dk
//
// Last changes: SupportedIO removed
//
unit HIPSLoader;

interface

uses Classes, SysUtils, LinarBitmap, Streams, TextStrm, Graphics, DelphiStream, MemUtils, Dialogs, Monitor;

resourcestring
  rsErrorInBitmapData = 'Error in bitmap data';
  rsHIPSImageFile     = 'HIPS image';

type
 THIPSGraphic = class(TLinarGraphic)
                  procedure LoadFromStream(Stream: TStream); override;
                end;

implementation

const
  FileExtension1 = 'HIP';
  FileExtension2 = 'HIPS';

//==================================================================================================
// THIPSLoader
//==================================================================================================

type
 THIPSLoader = class(TBitmapLoader)
             public
               function CanLoad(const Ext: string): Boolean; override;
               function CanSave(const Ext: string): Boolean; override;

               function GetLoadFilter: string; override;
               function GetSaveFilter: string; override;

               procedure LoadFromStream(InStream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap); override;
             end;

function THIPSLoader.GetLoadFilter: string;
begin
  Result:=rsHIPSImageFile+' (*.hips)|*.hips;*.hip';
end;

function THIPSLoader.GetSaveFilter: string;
begin
  Result:='';
end;

function THIPSLoader.CanLoad(const Ext: string): Boolean;
begin
  Result:=(Ext=FileExtension1) or (Ext=FileExtension2) ;
end;

function THIPSLoader.CanSave(const Ext: string): Boolean;
begin
  Result:=False;
end;

procedure THIPSLoader.LoadFromStream(InStream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap);
var
  X, Y, Planes, Skip, PixCount, T, D : Integer;
  Stream : TTextStream;
  Str, HeightStr : string;
  Pix : ^Byte;
  Pix24 : ^RGBRec;
  F : Single;
  F3 : packed record
         A1, A2, A3 : Single;
       end;
  MapType : (mtUnknown,mt8bit,mt24bit,mtFloat,mtFloat2);
begin
  Stream:=TTextStream.Create(-1,0,InStream);
  try
    Stream.NewLineChar:=10;
    Stream.SkipChar:=10;
    Stream.ReadLn(Str);
    Stream.ReadLn(Str);
    X:=0;
    repeat
      Stream.ReadLn(Str);
      Val(Str,Planes,T);
      Inc(X);
    until (T=0) and (Planes<500) or (X>200);
    Stream.ReadLn(Str);
    Stream.ReadLn(HeightStr); // Height
    Y:=StrToInt(HeightStr);
    Stream.ReadLn(Str); // Width
    X:=StrToInt(Str);
    Stream.ReadLn(Str);
    if Str<>HeightStr then
    begin
      if Str='8' then MapType:=mt8bit
      else raise ELinearBitmap.Create(rsUnsupportedBitmapFormat);
      Stream.ReadLn(Str); // 0
      Stream.ReadLn(Str); // 0
      Stream.ReadLn(Str); // Creator
      Stream.ReadLn(Str);
    end
    else
    begin
      Stream.ReadLn(Str); // Width
      Stream.ReadLn(Str); // 0
      Stream.ReadLn(Str); // 0
      Stream.ReadLn(Str); // Pixel format
      if Str='0' then MapType:=mt8bit
      else if Str='3' then MapType:=mtFloat2
      else if Str='35' then MapType:=mt24bit
      else if Str='37' then MapType:=mtFloat
      else raise ELinearBitmap.Create(rsUnsupportedBitmapFormat);
      Stream.ReadLn(Str); // Format specific, usually number of color planes
      Val(Str,Planes,T);
      if (T<>0) or (Planes<1) or (Planes>500) then Planes:=1;

      Stream.ReadLn(Str); // Number of bytes to skip
      Val(Str,Skip,T);
      if (T=0) and (Skip>0) then CopyStream(Stream,nil,Skip);
      Stream.ReadLn(Str); // Number of bytes to skip
      Val(Str,Skip,T);
      if (T=0) and (Skip>0) then CopyStream(Stream,nil,Skip);
      Stream.ReadLn(Str); // "0"
      Val(Str,Skip,T);
      if (T=0) and (Skip>0) then
      for T:=1 to Skip do Stream.ReadLn(Str);

      Stream.ReadLn(Str); // " 0"
      {repeat
        Stream.ReadLn(Str);
      until (Length(Str)>1) and (Pos(' 0',Str)=Length(Str)-1);}
    end;

    Stream.NoDataExcept:=True;
    PixCount:=X*Y;
    if MapType=mt8bit then
    begin
      if (Planes>1) and Assigned(ProgressUpdate) then
      begin
        Str:='1';
        if not InputQuery('Select plane','Select plane to load (1-'+IntToStr(Planes)+')',Str) then Abort;
        T:=StrToInt(Str);
        if T>1 then CopyStream(Stream,nil,(T-1)*X*Y);
      end;
      Bitmap.New(X,Y,pf8bit);
      Bitmap.Palette^:=GrayPal;
      Stream.Read(Bitmap.Map^,Bitmap.Size);
    end
    else if MapType=mt24bit then
    begin
      Bitmap.New(X,Y,pf24bit);
      Pix24:=@Bitmap.Map^;
      for X:=1 to PixCount do
      begin
        Stream.Read(Pix24^.R,1);
        Stream.Read(Pix24^.G,1);
        Stream.Read(Pix24^.B,1);
        Inc(Pix24);
        if Assigned(ProgressUpdate) and (X and $511=0) then ProgressUpdate(X*100 div PixCount);
      end;
    end
    else if MapType=mtFloat then
    begin
      Bitmap.New(X,Y,pf24bit);
      Pix24:=@Bitmap.Map^;
      for X:=1 to PixCount do
      begin
        Stream.Read(F3,SizeOf(F3));
        D:=Round(F3.A1); if D>255 then D:=255 else if D<0 then D:=0;
        Pix24^.B:=D;
        D:=Round(F3.A2); if D>255 then D:=255 else if D<0 then D:=0;
        Pix24^.G:=D;
        D:=Round(F3.A3); if D>255 then D:=255 else if D<0 then D:=0;
        Pix24^.R:=D;
        Inc(Pix24);
        if Assigned(ProgressUpdate) and (X and $511=0) then ProgressUpdate(X*100 div PixCount);
      end;
    end
    else if MapType=mtFloat2 then
    begin
      if Planes=1 then
      begin
        Bitmap.New(X,Y,pf8bit);
        Bitmap.Palette^:=GrayPal;
        Pix:=@Bitmap.Map^;
        for X:=1 to PixCount do
        begin
          Stream.Read(F,SizeOf(F));
          Swap4(Cardinal(Pointer(@F)^));
          D:=Round(F); if D>255 then D:=255 else if D<0 then D:=0;
          Pix^:=D;
          Inc(Pix);
          if Assigned(ProgressUpdate) and (X and $511=0) then ProgressUpdate(X*100 div PixCount);
        end;
      end
      else
      if Planes>1 then
      begin
        Bitmap.New(X,Y,pf24bit);
        Pix24:=@Bitmap.Map^;
        for X:=1 to PixCount do
        begin
          Stream.Read(F,SizeOf(F));
          D:=Round(F); if D>255 then D:=255 else if D<0 then D:=0;
          Pix24^.R:=D;
          Inc(Pix24);
        end;
        if Assigned(ProgressUpdate) then ProgressUpdate(100 div Planes);
        Pix24:=@Bitmap.Map^;
        for X:=1 to PixCount do
        begin
          Stream.Read(F,SizeOf(F));
          D:=Round(F); if D>255 then D:=255 else if D<0 then D:=0;
          Pix24^.G:=D;
          Inc(Pix24);
        end;
        if Planes>2 then
        begin
          if Assigned(ProgressUpdate) then ProgressUpdate(200 div Planes);
          Pix24:=@Bitmap.Map^;
          for X:=1 to PixCount do
          begin
            Stream.Read(F,SizeOf(F));
            D:=Round(F); if D>255 then D:=255 else if D<0 then D:=0;
            Pix24^.B:=D;
            Inc(Pix24);
          end;
          if Assigned(ProgressUpdate) then ProgressUpdate(100);
        end;
      end;
    end
  finally
    Stream.Free;
  end;
end;

//==================================================================================================
// THIPSGraphic
//==================================================================================================

procedure THIPSGraphic.LoadFromStream(Stream: TStream);
var
  Filter : TDelphiFilterStream;
begin
  Filter:=TDelphiFilterStream.Create(Stream);
  try
    FImage.LoadFromStream(Filter,FileExtension1);
  finally
    Filter.Free;
  end;
end;

var
  Loader : THIPSLoader;
initialization
  Loader:=THIPSLoader.Create;
  LinarBitmap.AddLoader(Loader);
  TPicture.RegisterFileFormat(FileExtension1,rsHIPSImageFile,THIPSGraphic);
  TPicture.RegisterFileFormat(FileExtension2,rsHIPSImageFile,THIPSGraphic);
finalization
  TPicture.UnregisterGraphicClass(THIPSGraphic);
  Loader.Free;
end.

