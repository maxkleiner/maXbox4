unit xrtl_util_FileVersion;

{$INCLUDE xrtl.inc}

interface

const
  fvsComments         = 'Comments';
  fvsCompanyName      = 'CompanyName';
  fvsFileDescription  = 'FileDescription';
  fvsFileVersion      = 'FileVersion';
  fvsInternalName     = 'InternalName';
  fvsLegalCopyright   = 'LegalCopyright';
  fvsLegalTrademarks  = 'LegalTrademarks';
  fvsOriginalFilename = 'OriginalFilename';
  fvsPrivateBuild     = 'PrivateBuild';
  fvsProductName      = 'ProductName';
  fvsProductVersion   = 'ProductVersion';
  fvsSpecialBuild     = 'SpecialBuild';

type
  TXRTLNumberVersionInfoIndex = (viMajor, viMinor, viRelease, viBuild);
  TXRTLNumberVersionInfo      = array[viMajor .. viBuild] of Integer;

  TXRTLFileType = (ftUnknown, ftApplication, ftDLL, ftDriver, ftFont, ftVXD, ftStaticLibrary);

  TXRTLFileVersion = class
  private
    FFileName: string;
    FFileVersion: TXRTLNumberVersionInfo;
    FProductVersion: TXRTLNumberVersionInfo;
    FFileType: TXRTLFileType;
    FDateTime: TDateTime;
    FDebug: Boolean;
    FPatched: Boolean;
    FPreRelease: Boolean;
    FPrivateBuild: Boolean;
    FInfoInferred: Boolean;
    FSpecialBuild: Boolean;
    FOS: Integer;
    FFileSubType: Integer;
    FCharset: Integer;
    FLanguage: Integer;
    procedure  ReadFixedInfo;
    function   GetFileVersionString: string;
    function   GetProductVersionString: string;
    function   GetVersionString(const Key: string): string;
  protected
  public
    constructor Create(const AFileName: string; ALanguage: Integer = 0; ACharset: Integer = $4E4);
    destructor Destroy; Override;
    property   FileName: string read FFileName;
    property   FileVersion: TXRTLNumberVersionInfo read FFileVersion;
    property   FileVersionString: string read GetFileVersionString;
    property   ProductVersion: TXRTLNumberVersionInfo read FProductVersion;
    property   ProductVersionString: string read GetProductVersionString;
    property   FileType: TXRTLFileType read FFileType;
    property   FileSubType: Integer read FFileSubType;
    property   DateTime: TDateTime read FDateTime;
    property   Debug: Boolean read FDebug;
    property   Patched: Boolean read FPatched;
    property   PreRelease: Boolean read FPreRelease;
    property   PrivateBuild: Boolean read FPrivateBuild;
    property   SpecialBuild: Boolean read FSpecialBuild;
    property   InfoInferred: Boolean read FInfoInferred;
    property   OS: Integer read FOS;
    property   VersionString[const Key: string]: string read GetVersionString;
    property   Language: Integer read FLanguage Write FLanguage;
    property   Charset: Integer read FCharset Write FCharset;
  published
  end;

implementation

Uses
  Windows, SysUtils;

{ TXRTLFileVersion }

constructor TXRTLFileVersion.Create(const AFileName: string; ALanguage, ACharset: Integer);
begin
  Inherited Create;
  FFileName:= AFileName;
  FLanguage:= ALanguage;
  FCharset:= ACharset;
  ReadFixedInfo;
end;

Destructor TXRTLFileVersion.Destroy;
begin
  Inherited Destroy;
end;

procedure TXRTLFileVersion.ReadFixedInfo;
var
  AFileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
  FileTime: TFILETIME;
  SystemTime: TSYSTEMTIME;

  function IsFlagSet(Flag: Integer): Boolean;
  begin
    Result:= ((FI.dwFileFlagsMask and Flag) <> 0) and
             ((FI.dwFileFlags and Flag) <> 0);
  end;

begin
  ZeroMemory(@FFileVersion, Sizeof(FFileVersion));
  ZeroMemory(@FProductVersion, Sizeof(FProductVersion));
  if not FileExists(FFileName) then Exit;
  FDateTime:= FileDateToDateTime(FileAge(FFileName));
  AFileName:= FileName;
  InfoSize:= GetFileVersionInfoSize(PChar(AFileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(AFileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
        begin
          FFileVersion[viMajor]:=      (FI.dwFileVersionMS shr 16) and $FFFF;
          FFileVersion[viMinor]:=        FI.dwFileVersionMS and $FFFF;
          FFileVersion[viRelease]:=    (FI.dwFileVersionLS shr 16) and $FFFF;
          FFileVersion[viBuild]:=        FI.dwFileVersionLS and $FFFF;
          FProductVersion[viMajor]:=   (FI.dwProductVersionMS shr 16) and $FFFF;
          FProductVersion[viMinor]:=     FI.dwProductVersionMS and $FFFF;
          FProductVersion[viRelease]:= (FI.dwProductVersionLS shr 16) and $FFFF;
          FProductVersion[viBuild]:=     FI.dwProductVersionLS and $FFFF;
          case FI.dwFileType of
            VFT_UNKNOWN:    FFileType:= ftUnknown;
            VFT_APP:        FFileType:= ftApplication;
            VFT_DLL:        FFileType:= ftDLL;
            VFT_DRV:        FFileType:= ftDriver;
            VFT_FONT:       FFileType:= ftFont;
            VFT_VXD:        FFileType:= ftVXD;
            VFT_STATIC_LIB: FFileType:= ftStaticLibrary;
          else
            FFileType:= ftUnknown;
          end;
          FFileSubType:= FI.dwFileSubtype;
          if (FI.dwFileDateLS <> 0) Or (FI.dwFileDateMS <> 0) then
          begin
            FileTime.dwLowDateTime:= FI.dwFileDateLS;
            FileTime.dwHighDateTime:= FI.dwFileDateMS;
            FileTimeToSystemTime(FileTime, SystemTime);
            FDateTime:= SystemTimeToDateTime(SystemTime);
          end;
          FDebug:=        IsFlagSet(VS_FF_DEBUG);
          FInfoInferred:= IsFlagSet(VS_FF_INFOINFERRED);
          FPatched:=      IsFlagSet(VS_FF_PATCHED);
          FPreRelease:=   IsFlagSet(VS_FF_PRERELEASE);
          FPrivateBuild:= IsFlagSet(VS_FF_PRIVATEBUILD);
          FSpecialBuild:= IsFlagSet(VS_FF_SPECIALBUILD);
          FOS:= FI.dwFileOS;
        end;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

function TXRTLFileVersion.GetFileVersionString: string;
begin
  Result:= Format('%d.%d.%d.%d', [FFileVersion[viMajor], FFileVersion[viMinor],
                                    FFileVersion[viRelease], FFileVersion[viBuild]]);
end;

function TXRTLFileVersion.GetProductVersionString: string;
begin
  Result:= Format('%d.%d.%d.%d', [FProductVersion[viMajor], FProductVersion[viMinor],
                                    FProductVersion[viRelease], FProductVersion[viBuild]]);
end;

function TXRTLFileVersion.GetVersionString(const Key: string): string;
var
  AFileName, AKey: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  VerSize: DWORD;
  S: PChar;
begin
  Result:= '';
  AKey:= Format('\StringFileInfo\%.4x%.4x\%s', [FLanguage, FCharset, Key]);
  AFileName:= FFileName;
  InfoSize:= GetFileVersionInfoSize(PChar(AFileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(AFileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, PChar(AKey), Pointer(S), VerSize) then
        begin
          SetLength(Result, StrLen(S));
          StrCopy(PChar(Result), S);
        end;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

end.
