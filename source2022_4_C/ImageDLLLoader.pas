/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ImageDLLLoader.pas - Image file format plugin wrapper
// -----------------------------------------------------
// Version:   2005-10-02
// Maintain:  Michael Vinther    |     mv@logicnetĚdk
//
// Last changes:
//   YCbCr/Lab support in LoadFromFile
//
unit ImageDLLLoader;

interface

uses Streams, Classes, Windows, SysUtils, LinarBitmap, Graphics, FileUtils, Monitor, Dialogs,
  MemUtils, DynamicLists, AnalyzerPlugins;

{DEFINE ImageDLLDebug}

type
  TLoadImage = function(FileName,FileType: PChar; var Image: TImageContainer): Integer; stdcall;
  TSaveImage = function(FileName,FileType: PChar; var Image: TImageContainer): Integer; stdcall;
  TGetFilter = function: PChar; stdcall;
  TFreeImage = function(var Image: TImageContainer): Integer; stdcall;

  TImageDLLInfo = record   //TImageDLLInfo = object
                    Handle : THandle;
                    LoadFormats : string;
                    SaveFormats : string;
                    LoadImage : TLoadImage;
                    SaveImage : TSaveImage;
                    FreeImage : TFreeImage;
                  end;

  TImageDLLInfoArray = array[0..3] of TImageDLLInfo;
  TLoadPluginCallback = procedure(const FileName: string) of object;

  TImageDLLLoader = class(TBitmapLoader)
    private
      Loader : ^TImageDLLInfoArray;
    public
      Loaders : TDynamicList;
      CompOptions : string;

      constructor Create;
      destructor Destroy; override;

      function FindDLLs(Path: string; CallBack: TLoadPluginCallback=nil): Boolean;

      function GetLoadFilter: string; override;
      function GetSaveFilter: string; override;

      procedure LoadFromFile(const FileName,FileType: string; Bitmap: TLinarBitmap); override;
      procedure SaveToFile(const FileName,FileType: string; Bitmap: TLinarBitmap); override;
    end;

var
  Default : TImageDLLLoader = NIL;

implementation

uses DelphiStream, PluginLinearBitmap, BitmapConversion;

constructor TImageDLLLoader.Create;
begin
  inherited;
  CompOptions:=#0;
  Loaders:=TDynamicList.Create(SizeOf(TImageDLLInfo),Loader);
end;

destructor TImageDLLLoader.Destroy;
var I : Integer;
begin
  for I:=0 to Loaders.Count-1 do begin
    if Loader[I].Handle<>0 then FreeLibrary(Loader[I].Handle);
    Finalize(Loader[I]);
  end;
  Loaders.Free;
  inherited;
end;

function TImageDLLLoader.GetLoadFilter: string;
var I : Integer;
begin
  Result:='';
  for I:=0 to Loaders.Count-1 do if Assigned(Loader[I].LoadImage) and (Loader[I].LoadFormats<>'') then
  begin
    if (Result<>'') and (Result[Length(Result)]<>'|') then Result:=Result+'|';
    Result:=Result+Loader[I].LoadFormats;
  end;
end;

function TImageDLLLoader.GetSaveFilter: string;
var I : Integer;
begin
  Result:='';
  for I:=0 to Loaders.Count-1 do if Assigned(Loader[I].SaveImage) and (Loader[I].SaveFormats<>'') then
  begin
    if (Result<>'') and (Result[Length(Result)]<>'|') then Result:=Result+'|';
    Result:=Result+Loader[I].SaveFormats;
  end;
end;

function TImageDLLLoader.FindDLLs(Path: string; CallBack: TLoadPluginCallback): Boolean;
var
  SearchRec : TSearchRec;
  FindResult : Integer;
  DLLName, Ext, Filter : string;
  GetFilter : TGetFilter;
  I, L : Integer;
begin
  Result:=False;
  Path:=ForceBackslash(Path);
  FindResult:=FindFirst(Path+'*.dll',faAnyFile,SearchRec);
  try
    {$IFDEF ImageDLLDebug}
    if Result<>0 then ShowMessage('No DLLs found');
    {$ENDIF}
    while FindResult=0 do
    begin
      if SearchRec.Attr and (faDirectory or faVolumeID)=0 then
      begin
        if Assigned(CallBack) then CallBack(SearchRec.Name);

        DLLName:=Path+SearchRec.Name;
        L:=Loaders.Count;
        Loaders.IncCount;
        Initialize(Loader[L]);

        Loader[L].Handle:=LoadLibrary(PChar(DLLName));

        if Loader[L].Handle<>0 then
        begin
          Loader[L].LoadImage:=GetProcAddress(Loader[L].Handle,'?LibLoadImage@@YGHPAD0PAUTImageContainer@@@Z');
          Loader[L].SaveImage:=GetProcAddress(Loader[L].Handle,'?LibSaveImage@@YGHPAD0PAUTImageContainer@@@Z');
          Loader[L].FreeImage:=GetProcAddress(Loader[L].Handle,'?LibFreeImage@@YGHPAUTImageContainer@@@Z');

          if (Assigned(@Loader[L].LoadImage) or Assigned(@Loader[L].SaveImage)) and Assigned(@Loader[L].FreeImage) then
          begin
            GetFilter:=GetProcAddress(Loader[L].Handle,'?LibGetLoadFilter@@YGPADXZ');
            if Assigned(@GetFilter) then
            begin
              Filter:=GetFilter;
              Loader[L].LoadFormats:=Filter;

              Filter:=AnsiUpperCase(Filter)+'|';
              I:=0;
              repeat
                I:=FastLocate2Bytes(Filter[1],I,Length(Filter),Byte('*')+Word(Byte('.')) shl 8)+1;
                if I>0 then
                begin
                  Inc(I,2);
                  Ext:='';
                  while Filter[I] in ['a'..'z','A'..'Z','0'..'9','_'] do
                  begin
                    Ext:=Ext+Filter[I];
                    Inc(I);
                  end;
                  if Pos('*.'+Ext,Filter)=I-Length(Ext)-2 then
                    TPicture.RegisterFileFormat(Ext,Ext,TLinearGraphic);
                end;
              until I=0;
            end
            else Loader[L].LoadFormats:='';

            GetFilter:=GetProcAddress(Loader[L].Handle,'?LibGetSaveFilter@@YGPADXZ');
            if Assigned(@GetFilter) then Loader[L].SaveFormats:=GetFilter
            else Loader[L].SaveFormats:='';

            Result:=True;
          end
          else
          begin
            FreeLibrary(Loader[L].Handle);
            Finalize(Loader[L]);
            Loaders.Delete(L);
            {$IFDEF ImageDLLDebug} RaiseLastWin32Error {$ENDIF};
          end;
        end
        {$IFDEF ImageDLLDebug} else RaiseLastWin32Error; {$ENDIF};
      end;
      FindResult:=FindNext(SearchRec);
    end;
  finally
    FindClose(SearchRec);
  end;
end;

procedure TImageDLLLoader.LoadFromFile(const FileName,FileType: string; Bitmap: TLinarBitmap);
var
  Image : TImageContainer;
  Result, C, L : Integer;
  FormatMask : string;
  TempExt : array[1..MAX_PATH] of Char;
begin
  L:=-1;
  FormatMask:='*.'+FileType;
  for C:=0 to Loaders.Count-1 do if Pos(FormatMask,UpperCase(Loader[C].LoadFormats))<>0 then
  begin
    L:=C;
    Break;
  end;
  if L<0 then raise ELinearBitmap.Create(rsUnsupportedFileFormat);

  Image.Options:=PChar(CompOptions);
  StrLCopy(@TempExt,PChar(FileType),SizeOf(TempExt));
  Result:=Loader[L].LoadImage(PChar(FileName),@TempExt,Image);
  if Result=0 then
  try
    LinearBitmapFromImageContainer(Bitmap,Image);
    if Image.Options='YCbCr' then ConvertColorSpace(Bitmap,InvYCbCrTransform)
    else if Image.Options='Lab' then ConvertColorSpace(Bitmap,ColorTransformLab2RGB);
    if Image.PixelFormat and $0f>3 then raise ELinearBitmap.Create('The image contains '+IntToStr(Image.PixelFormat and $0f)+' color planes, only 3 were loaded');
  finally
    Loader[L].FreeImage(Image);
  end
  else RaisePluginError(Result,rsErrorInBitmapData+': %d');
end;

procedure TImageDLLLoader.SaveToFile(const FileName,FileType: string; Bitmap: TLinarBitmap);
var
  Image : TImageContainer;
  Result, L, C : Integer;
  FormatMask : string;
  TempExt : array[1..MAX_PATH] of Char;
begin
  L:=-1;
  FormatMask:='*.'+FileType;
  for C:=0 to Loaders.Count-1 do if Pos(FormatMask,UpperCase(Loader[C].SaveFormats))<>0 then
  begin
    L:=C;
    Break;
  end;
  if L<0 then raise ELinearBitmap.Create(rsUnsupportedFileFormat);

  LinearBitmapToImageContainer(Bitmap,Image);
  Image.Options:=PChar(CompOptions);
  StrLCopy(@TempExt,PChar(FileType),SizeOf(TempExt));
  Result:=Loader[L].SaveImage(PChar(FileName),@TempExt,Image);
  if Result<>0 then RaisePluginError(Result,'Error writing image file: %d');
end;

initialization
  Default:=TImageDLLLoader.Create;
  LinarBitmap.AddLoader(Default);
finalization
  Default.Free;
end.




