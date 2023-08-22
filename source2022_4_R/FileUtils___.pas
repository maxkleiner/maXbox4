unit FileUtils;

interface

uses
    Classes;

type
    TFileAttributes=(faReadOnly,faHidden,faSysFile,faVolumeID,faDirectory,faArchive,faAnyFile);
    TAttributeSet=set of TFileAttributes;

    TFileSearch=class(TObject)
      public
        constructor Create;
        destructor Destroy; override;

        procedure Search(const Directory,Mask:string); overload;
        procedure Search(const Path:string); overload;

      private
        FRecurse:Boolean;
        FAttributes:Integer;
        FList:TStringList;

        function GetAttributes:TAttributeSet;
        procedure SetAttributes(Attributes:TAttributeSet);

        function GetRecurse:Boolean;
        procedure SetRecurse(Recurse:Boolean);

        function GetList:TStringList;

      published
        property Attributes:TAttributeSet read GetAttributes write SetAttributes;
        property Recurse:Boolean read GetRecurse write SetRecurse;
        property List:TStringList read GetList;
    end;

implementation

uses
    SysUtils;

constructor TFileSearch.Create;
begin
    inherited Create;
    Recurse:=True;
    Attributes:=[faReadOnly,faArchive];
    FList:=TStringList.Create;
end;

destructor TFileSearch.Destroy;
begin
    FList.Free;
    inherited Destroy;
end;

function TFileSearch.GetAttributes:TAttributeSet;
begin
    Result:=[];
    if (FAttributes and SysUtils.faReadOnly)=SysUtils.faReadOnly then
        Include(Result,faReadOnly);
    if (FAttributes and SysUtils.faHidden)=SysUtils.faHidden then
        Include(Result,faHidden);
    if (FAttributes and SysUtils.faSysFile)=SysUtils.faSysFile then
        Include(Result,faSysFile);
    if (FAttributes and SysUtils.faVolumeID)=SysUtils.faVolumeID then
        Include(Result,faVolumeID);
    if (FAttributes and SysUtils.faDirectory)=SysUtils.faDirectory then
        Include(Result,faDirectory);
    if (FAttributes and SysUtils.faArchive)=SysUtils.faArchive then
        Include(Result,faArchive);
    if (FAttributes and SysUtils.faAnyFile)=SysUtils.faAnyFile then
        Include(Result,faAnyFile);
end;

procedure TFileSearch.SetAttributes(Attributes:TAttributeSet);
begin
    FAttributes:=0;
    if (faReadOnly in Attributes) then
        FAttributes:=FAttributes or SysUtils.faReadOnly;
    if (faHidden in Attributes) then
        FAttributes:=FAttributes or SysUtils.faHidden;
    if (faSysFile in Attributes) then
        FAttributes:=FAttributes or SysUtils.faSysFile;
    if (faVolumeID in Attributes) then
        FAttributes:=FAttributes or SysUtils.faVolumeID;
    if (faDirectory in Attributes) then
        FAttributes:=FAttributes or SysUtils.faDirectory;
    if (faArchive in Attributes) then
        FAttributes:=FAttributes or SysUtils.faArchive;
    if (faAnyFile in Attributes) then
        FAttributes:=FAttributes or SysUtils.faAnyFile;
end;

function TFileSearch.GetRecurse:Boolean;
begin
    Result:=FRecurse;
end;

procedure TFileSearch.SetRecurse(Recurse:Boolean);
begin
    FRecurse:=Recurse;
end;

function TFileSearch.GetList:TStringList;
begin
    Result:=FList;
end;

procedure TFileSearch.Search(const Directory,Mask:string);
var
    FileInfo:TSearchRec;
begin
    if FindFirst(Directory+Mask,FAttributes and (not SysUtils.faDirectory),FileInfo)=0 then begin
        try
            repeat
                FList.Add(Directory+FileInfo.Name);
            until FindNext(FileInfo)<>0;
        finally
            SysUtils.FindClose(FileInfo);
        end;
    end;

    if not FRecurse then
        Exit;

    if FindFirst(Directory+'*.*',SysUtils.faDirectory,FileInfo)=0 then begin
        try
            repeat
                if ((FileInfo.Attr and SysUtils.faDirectory)=SysUtils.faDirectory) and (FileInfo.Name[1]<>'.') then
                    Search(IncludeTrailingPathDelimiter(Directory+FileInfo.Name),Mask);
            until FindNext(FileInfo)<>0;
        finally
            SysUtils.FindClose(FileInfo);
        end;
    end;
end;

procedure TFileSearch.Search(const Path:string);
var
    Directory:string;
begin
    Directory:=IncludeTrailingPathDelimiter(ExtractFilePath(Path));
    if Directory='\' then
        Directory:='';
    Search(Directory,ExtractFileName(Path));
end;

end.
