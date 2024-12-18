﻿unit FlyFilesUtils;

(* ************************************************ *)
(*　　　　　　　　　　　　　　　　　　　　　　　　　*)
(*　　设计：爱吃猪头肉 & Flying Wang 2013-11-30　　 *)
(*　　　　　　上面的版权声明请不要移除。　　　　　　*)
(*　　　　　　Ver 1.0.2014.808  　　　　　　　　　　*)
(*　　　　　　　　　　　　　　　　　　　　　　　　　*)
(* ************************************************ *)

//1.0.2014.1108
//支持 UTF8 的检查。

//1.0.2014.908
//支持 XE7。

//1.0.2014.808
//增加函数 IsPadOrPC。

//1.0.2014.805
//增加安卓下的获取 内存 SD 卡空间的函数。

//1.0.2014.419
//增加对 XE6 的支持。

//1.0.2014.225
//增加对 JNI 的接口查找功能。不完善。

//1.0.2013.1219
//在 亚瑟(Arthur)  3140223 的启发下，增加了更多的 SD 目录。

//1.0.2013.1217
//增加一个 FindSDCardSubPath 函数，用于查找指定的目录。

//1.0.2013.1206
//增加 [佛山]N.E(1024317)  9:36:38 提供的几个 SD 卡的路径。

interface

uses SysUtils,
  Classes,
{$IFDEF ANDROID}
  Androidapi.JNIBridge,
  Androidapi.IOUtils,
{$ENDIF ANDROID}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  Posix.Dlfcn, Posix.Fcntl, Posix.SysStat, Posix.SysTime, Posix.SysTypes, Posix.Locale,
{$ENDIF POSIX}
{$IFDEF PC_MAPPED_EXCEPTIONS}
  System.Internal.Unwinder,
{$ENDIF PC_MAPPED_EXCEPTIONS}
{$IFDEF MACOS}
  Macapi.Mach, Macapi.CoreServices, Macapi.CoreFoundation,
{$ENDIF MACOS}
  SysConst;
  //System.IOUtils;

var
  Error_NotFoundFileManager_Str: string = 'Not Found FileManager.';


///	<summary>
///	  返回大小写敏感的文件或路径名称
///	</summary>
///	<param name="FileName">
///	  文件或路径名
///	</param>
///	<param name="RootPath">
///	  <para>
///	    检查路径的根目录
///	  </para>
///	  <para>
///	    当大小写检查到此目录时停止，不再继续检查。
///	  </para>
///	</param>
function GetCaseSensitiveFileName(const FileName: string; RootPath: string = ''): string;


const
  ///	<summary>
  ///	  外置设备的数量
  ///	</summary>
  OTGDeivceCount = 16;

  ///	<summary>
  ///	  USB 磁盘，例如 U 盘、移动硬盘等
  ///	</summary>
  UsbDiskStartIndex = 255;

  ///	<summary>
  ///	  外置光驱
  ///	</summary>
  CDROMStartIndex = 255 + OTGDeivceCount;

const
  ///	<summary>
  ///	  默认的删除等待时间，单位微秒
  ///	</summary>
  DeleteDirectories_WaitMinSecond = 2000;


///	<summary>
///	  检查 SD 卡或路径是否可用
///	</summary>
function isPathCanUseNow(const PathOrDir: string; const Default: Boolean = True): Boolean;

///	<summary>
///	  检查 SD 卡或路径是否写入
///	</summary>
function TestPathCanWrite(const PathOrDir: string): Boolean;

///	<summary>
///	  获取 手机存储 或 SD 卡的路径
///	</summary>
///	<param name="Index">
///	  0 为 手机存储 1 为 SD 卡
///	</param>
///	<returns>
///	  <para>
///	    如果找到，返回路径。带 / 或 \
///	  </para>
///	  <para>
///	    没找到，返回一个错误的路径。
///	  </para>
///	</returns>
function GetSDCardPath(Index: Integer = 0): string;

///	<summary>
///	  查找 手机存储 或 SD 卡上的某个路径
///	</summary>
///	<param name="SubPath">
///	  被查找的子路径
///	</param>
///	<param name="Index">
///	  0 为 手机存储 1 为 SD 卡
///	</param>
///	<returns>
///	  如果找到，返回路径。带 / 或 \ 没找到，返回一个错误的路径。
///	</returns>
function FindSDCardSubPath(SubPath: string; Index: Integer = 0): string;

///	<summary>
///	  获取当成工程的运行路径
///	</summary>
function GetAppPath: string;

///	<summary>
///	  查找一个路径下的指定格式的文件
///	</summary>
///	<param name="Path">
///	  路径，必须用通配符结束。例如 /*
///	</param>
///	<param name="Attr">
///	  需要查找的文件的属性
///	</param>
///	<param name="List">
///	  返回一个文件名或目录名的列表
///	</param>
///	<param name="JustFile">
///	  是否只查找文件
///	</param>
///	<returns>
///	  无意义
///	</returns>
function BuildFileListInAPath(const Path: string; const Attr: Integer; const List: TStrings;
  JustFile: Boolean = False): Boolean; overload;

///	<summary>
///	  查找一个路径下的指定格式的文件
///	</summary>
///	<param name="Path">
///	  路径，必须用通配符结束。例如 /*
///	</param>
///	<param name="Attr">
///	  需要查找的文件的属性
///	</param>
///	<param name="JustFile">
///	  是否只查找文件
///	</param>
///	<returns>
///	  返回换行分割的文件名或目录的列表
///	</returns>
function BuildFileListInAPath(const Path: string; const Attr: Integer;
  JustFile: Boolean = False): string; overload;

///	<summary>
///	  查找指定路径下的文件
///	</summary>
///	<param name="DirName">
///	  路径
///	</param>
///	<param name="SearchFilter">
///	  通配符组成的查找格式
///	</param>
///	<param name="FileAttribs">
///	  需要查找的文件的属性
///	</param>
///	<param name="isIncludeSubDirName">
///	  是否包含子目录的名字
///	</param>
///	<param name="Recursion">
///	  是否递归找子目录
///	</param>
///	<param name="FullName">
///	  是否返回完整路径
///	</param>
///	<returns>
///	  返回换行分割的文件名或目录的列表
///	</returns>
function GetFileNamesFromDirectory(const DirName: string; const SearchFilter: string = '*';
  const FileAttribs: Integer = faAnyFile; const isIncludeSubDirName: Boolean = False; const Recursion: Boolean = False;
  const FullName: Boolean = False): string;

//可以用 TDirectory.Delete 代替下面的功能。
///	<summary>
///	  删除目录下指定的文件
///	</summary>
///	<param name="Source">
///	  被删除的文件路径，可以使用通配符
///	</param>
///	<param name="AbortOnFailure">
///	  失败时是否退出
///	</param>
///	<param name="YesToAll">
///	  删掉所有文件，包括只读的。仅 WIN32 下有效。
///	</param>
///	<param name="WaitMinSecond">
///	  检查文件删除的等待时间，单位 微秒
///	</param>
///	<returns>
///	  是否删除完成
///	</returns>
function DeleteDirectoryByEcho(const Source: string;
  AbortOnFailure: Boolean = False; YesToAll: Boolean = True;
  WaitMinSecond: Integer = DeleteDirectories_WaitMinSecond): Boolean;

  ///	<summary>
///	  获取指定路径的总存储大小
///	</summary>
function GetTotalSpaceSize(Path: string = PathDelim): UInt64;
///	<summary>
///	  获取指定路径的可以使用的存储大小
///	</summary>
function GetAvailableSpaceSize(Path: string = PathDelim): UInt64;
///	<summary>
///	  获取指定路径的剩余（包括不可使用的）存储大小
///	</summary>
function GetFreeSpaceSize(Path: string = PathDelim): UInt64;

///	<summary>
///	  获取总内存大小
{$IFDEF ANDROID}
///   感谢[上海]故国(370620516)
{$ENDIF}
///	</summary>
function GetTotalMemorySize: UInt64;
///	<summary>
///	  获取剩余内存大小
{$IFDEF ANDROID}
///   感谢[上海]故国(370620516)
{$ENDIF}
///	</summary>
function GetFreeMemorySize: UInt64;

///	<summary>
///	  安卓 IOS 返回是否是 PAD(平板)
///   其他平台，返回 True
///   很多手机的 DPI 是错的，所以获取的尺寸也就不正常了，
///   所以个别手机会被识别成 PAD。
///	</summary>
function IsPadOrPC: Boolean;
//function IsPadOrPC(MiniScreenInches: Single = 6.2): Boolean;
//function IsPad: Boolean;


///	<summary>
///	  在其他 APP 中打开文件。
///	</summary>
function OpenFileOnExtApp(const FileName: string; Https: Boolean = True): Boolean;

function NowGMT_UTC: TDateTime;

///	<summary>
///	  获取完整 URL 的 Encode 结果。
///   Just UTF8
///	</summary>
function EncodeURLWithSchemeOrProtocol(const URL: string): string;

//上面是跨平台函数。
//下面是平台函数。

{$IFDEF ANDROID}

function GetVolumePaths: string;

function GetExternalStoragePath: string;

//var
//  ExterStoragePathCanRead: Boolean = True;
//  ExterStoragePathCanWrite: Boolean = True;
//  SDMountedMessageReceived: Boolean = False;
function GetExterStoragePath: string;
function GetInnerStoragePath: string;

///	<summary>
///	  It check SDCard0 Removable
///	</summary>
function GetIsExternalStorageRemovable: Boolean;

///	<summary>
///   很多手机的 DPI 是错的，所以获取的尺寸也就不正常了。
///	</summary>
function GetScreenClientInches: Single;

///	<summary>
///	  获取安卓下剩余内存大小
///	</summary>
//function GetActiveMemorySize: UInt64;

///	<summary>
///	  查找一个 JAVA 类是否可以使用
///	</summary>
///	<param name="NamePath">
///	  类的全路径
///	</param>
function IsCanFindJavaClass(const NamePath: string): Boolean;
function IsCanFindJavaMethod(const MethodName, Signature: string; const CalssNamePath: string = ''): Boolean;
function IsCanFindJavaStaticMethod(const MethodName, Signature: string; const CalssNamePath: string = ''): Boolean;

type
  TGetFileNameListener = reference to procedure(const IsOK: Boolean; const FileName:string);
  TGetFileNameLIsternerMethod = procedure (const IsOK: Boolean; const FileName:string) of object;

function OpenFileDialog(Title, FileExtension:string; GetFileNameCallBack: TGetFileNameListener): Boolean; overload;
function OpenFileDialog(Title, FileExtension:string; GetFileNameCallBack: TGetFileNameLIsternerMethod): Boolean; overload;

function CheckPermission(const APermissionName: string): Boolean;

const
  C_android_permission_EXTERNAL_STORAGE = 'android.permission.WRITE_EXTERNAL_STORAGE';
//  C_android_permission_WRITE_MEDIA = 'android.permission.WRITE_MEDIA_STORAGE';
function CanWriteExterStorage: Boolean;

/// <summary>
///   更新相册
/// </summary>
procedure UpdateAlbum(FileNames: string);

function ReadNoSizeFileToString(const AFileName: string): string;

//{$ENDIF}

function ReadFileToString(const AFileName: string): string;

{$ENDIF}

implementation

uses
{$IFDEF ANDROID}
{$IF CompilerVersion >= 27.0} // >= XE6
  Androidapi.Helpers,
//  FMX.Helpers.Android,
{$IFEND}
{$IF CompilerVersion < 28.0} // < XE7
  FMX.Helpers.Android,
{$IFEND}
  Androidapi.Jni,
  Androidapi.JNI.Environment,
  Androidapi.JNI.StatFs,
  Androidapi.JNI.Stream2,
  Androidapi.JNI.ActivityManager,
  Androidapi.JNI.JavaTypes,
  Androidapi.NativeActivity,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Util,
  Androidapi.JNI.android.os.storage.StorageManager,
  Androidapi.JNI.java.lang.FlyUtils,
  Androidapi.JNI.Webkit,
//  Androidapi.JNI.Embarcadero,
  Androidapi.JNI.App,
  Androidapi.JNI.Net,
  Androidapi.JNI.Media,
  Androidapi.JNI.Provider,
{$ENDIF}
{$IF DEFINED(IOS) or DEFINED(MACOS)}
  iOSapi.Foundation,
  Macapi.ObjectiveC,
  FMX.Helpers.iOS,
//  iOSapi.UIDevice2,
{$IFEND}
{$IFDEF MSWINDOWS}
  ShellApi,
{$ENDIF}
//  FMX.Dialogs,
{$IF CompilerVersion >= 29.0} //  XE8
  System.NetEncoding,
{$ELSE}
  IdURI,
{$IFEND}
  //System.Rtti,
  TypInfo,
  Messages,
  Math;


//来自 inc 内部的 类型。
{$IF DEFINED(IOS) or DEFINED(MACOS)}
type
{ Used by other time functions.  }
  tm = record
    tm_sec: Integer;            // Seconds. [0-60] (1 leap second)
    tm_min: Integer;            // Minutes. [0-59]
    tm_hour: Integer;           // Hours.[0-23]
    tm_mday: Integer;           // Day.[1-31]
    tm_mon: Integer;            // Month.[0-11]
    tm_year: Integer;           // Year since 1900
    tm_wday: Integer;           // Day of week [0-6] (Sunday = 0)
    tm_yday: Integer;           // Days of year [0-365]
    tm_isdst: Integer;          // Daylight Savings flag [-1/0/1]
    tm_gmtoff: LongInt;         // Seconds east of UTC
    tm_zone: MarshaledAString;  // Timezone abbreviation
  end;
  {$EXTERNALSYM tm}
  Ptm = ^tm;
{$ELSEIF DEFINED(ANDROID)}
{ Used by other time functions.  }
type
  tm = record
    tm_sec: Integer;            // Seconds. [0-60] (1 leap second)
    tm_min: Integer;            // Minutes. [0-59]
    tm_hour: Integer;           // Hours.[0-23]
    tm_mday: Integer;           // Day.[1-31]
    tm_mon: Integer;            // Month.[0-11]
    tm_year: Integer;           // Year since 1900
    tm_wday: Integer;           // Day of week [0-6] (Sunday = 0)
    tm_yday: Integer;           // Days of year [0-365]
    tm_isdst: Integer;          // Daylight Savings flag [-1/0/1]
    tm_gmtoff: LongInt;         // Seconds east of UTC
    tm_zone: MarshaledAString;         // Timezone abbreviation
  end;
  {$EXTERNALSYM tm}
  Ptm = ^tm;
{$IFEND}


//来自 inc 的函数定义。
{$IFDEF POSIX}
const
{$IFDEF UNDERSCOREIMPORTNAME}
  _PU = '_';
{$ELSE}
  _PU = '';
{$ENDIF}
const
  libc        = '/usr/lib/libc.dylib';
  libpthread  = '/usr/lib/libpthread.dylib';
  libiconv    = '/usr/lib/libiconv.dylib';
  libdl       = '/usr/lib/libdl.dylib';

{$IF not Declared(_PU)}
const
  // On Mac OSX, cdecl names have a preceeding underscore
  // if x86 native backend.
  {$IF Defined(UNDERSCOREIMPORTNAME)}
  _PU = '_';
  {$ELSE}
  _PU = '';
  {$IFEND}
  {$EXTERNALSYM _PU}
{$IFEND}

const
{$IFNDEF IOS}
  _INODE_SUFFIX = '$INODE64';
{$ELSE IOS}
  _INODE_SUFFIX = '';
{$ENDIF !IOS}
  {$EXTERNALSYM _INODE_SUFFIX}

//具体函数定义开始。
function _system(Name: MarshaledAString): Integer; cdecl;
  external libc name _PU + 'system';

function tempnam(const Path: MarshaledAString; const Prefix: MarshaledAString): MarshaledAString; cdecl;
  external libc name _PU + 'tempnam';
{$EXTERNALSYM tempnam}
procedure free(p: Pointer); cdecl;
  external libc name _PU + 'free';
{$EXTERNALSYM free}
function gettimeofday(var timeval: timeval; timezone: Pointer): Integer; cdecl;
  external libc name _PU + 'gettimeofday';
{$EXTERNALSYM gettimeofday}
function gmtime_r(var Timer: time_t; var UnixTime: tm): Ptm; cdecl;
  external libc name _PU + 'gmtime_r';
{$EXTERNALSYM gmtime_r}
{$ENDIF}

//可以开始写函数了。

function NowGMT_UTC: TDateTime;
{$IFDEF MSWINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  Result := EncodeDate(SystemTime.wYear, SystemTime.wMonth, SystemTime.wDay) +
    EncodeTime(SystemTime.wHour, SystemTime.wMinute, SystemTime.wSecond, SystemTime.wMilliseconds);
end;
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
var
  T: time_t;
  TV: timeval;
  UT: tm;
begin
  gettimeofday(TV, nil);
  T := TV.tv_sec;
  gmtime_r(T, UT);
  Result := EncodeDate(UT.tm_year + 1900, UT.tm_mon + 1, UT.tm_mday) +
    EncodeTime(UT.tm_hour, UT.tm_min, UT.tm_sec, TV.tv_usec div 1000);
end;
{$ENDIF POSIX}

function EncodeURLWithSchemeOrProtocol(const URL: string): string;
var
  Protocol: string;
  AURL: string;
  AIndex: Integer;
begin
{$IF CompilerVersion >= 29.0} //  XE8
   AURL := URL.Trim;
   Protocol := '';
   AIndex := AURL.IndexOf('//');
   if AIndex > 0 then
   begin
     Protocol := AURL.Substring(0, AIndex + 1); // has /
     AURL := AURL.Substring(AIndex + 1); // has /
   end;
   Result := Protocol + TNetEncoding.URL.EncodePath(AURL);
{$ELSE}
   Result := TIdURI.URLEncode(Result);
{$IFEND}
end;

function EncodeURLWithOutSchemeOrProtocol(const URL: string; Https: Boolean = True): string;
begin
  Result := URL;
  if FileExists(Result) then
  begin
{$IFDEF MSWINDOWS}
{$ELSE}
    if Result.Substring(0, 1) <> '/' then
    begin
      Result := '/' + Result;
    end;
    Result := 'file://' + Result;
{$ENDIF}
  end
  else
  begin
    if Https then
    begin
      Result := 'https://' + URL;
    end
    else
    begin
      Result := 'http://' + URL;
    end;
    Result := EncodeURLWithSchemeOrProtocol(Result);
  end;
end;


function OpenFileOnExtApp(const FileName: string; Https: Boolean = True): Boolean;
{$IFDEF ANDROID}
var
  Intent: JIntent;
  FileExtension: string;
  mime: JMimeTypeMap;
  MIMEType: JString;
  TempStr,
  FileToOpen: string;
  AJFile: JFile;
  AJUri: Jnet_Uri;
begin
// There may be an issue with the geo: prefix and URLEncode.
// will need to research
  Result := False;
  FileExtension := AnsiLowerCase(ExtractFileExt(FileName));
  mime := TJMimeTypeMap.JavaClass.getSingleton();
  MIMEType := nil;
  if mime <> nil then
  begin
    MIMEType := mime.getMimeTypeFromExtension(StringToJString(FileExtension));
  end;
  if MIMEType <> nil then
  begin
    // 调用相应程序打开当前程序
    Intent := TJIntent.Create;
    Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
    //TempStr := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath)
    TempStr := IncludeTrailingPathDelimiter(TPath.GetHomePath);
{$IF CompilerVersion >= 33.0} //  RAD10.3
    if FileExists(FileName) then
    begin
      FileToOpen := FileName;
    end
    else
    begin
      FileToOpen := EncodeURLWithOutSchemeOrProtocol(FileName, Https);
    end;
    if Pos(TempStr, FileToOpen) = 1 then
    begin
      AJFile := TJFile.JavaClass.init(StringToJString(FileToOpen));
      AJUri := TAndroidHelper.JFileToJURI(AJFile);
    end
    else
    begin
{$ELSE}
    begin
{$IFEND}
      FileToOpen := EncodeURLWithOutSchemeOrProtocol(FileName, Https);
      AJUri := StrToJURI(FileToOpen);
    end;
    Intent.setDataAndType(AJUri, MIMEType);
    try
      SharedActivity.startActivity(Intent);
      Result := True;
    except
    end;
  end;

end;
{$ELSE}
{$IFDEF IOS}
var
  NSU: NSUrl;
  AURL: string;
begin
  Result := False;
  AURL := EncodeURLWithOutSchemeOrProtocol(FileName, Https);
  // iOS doesn't like spaces, so URL encode is important.
  NSU := StrToNSUrl(AURL);
  if TOSVersion.Check(9) or SharedApplication.canOpenURL(NSU) then
  try
    Result := SharedApplication.openUrl(NSU);
  except
  end;
end;
{$ELSE}
{$IFDEF MSWINDOWS}
var
  AURL: string;
begin
  Result := False;
  AURL := EncodeURLWithOutSchemeOrProtocol(FileName, Https);
  try
    ShellExecute(GetActiveWindow, 'open', PChar(AURL), '', '', SW_MAXIMIZE);
    Result := True;
  except
  end;
end;
{$ELSE}
var
  M:TMarshaller;
  AURL: string;
begin
  Result := False;
  //AURL := 'open -a Safari ' +  EncodeURLWithOutSchemeOrProtocol(AURL);
  AURL := 'open ' +  EncodeURLWithOutSchemeOrProtocol(FileName, Https);
  try
    _system(M.AsAnsi(AURL, CP_UTF8).ToPointer);
    Result := True;
  except
  end;
//  raise Exception.Create('Not supported!');
end;
{$ENDIF MSWINDOWS}
{$ENDIF IOS}
{$ENDIF ANDROID}

function IsPadOrPC: Boolean;
{$IF DEFINED(IOS) or DEFINED(MACOS)}
{$IFDEF IOS}
begin
  Result := IsPad;
end;
{$ELSE IOS}
begin
  Result := True;
end;
{$ENDIF IOS}
{$IFEND IOS or MACOS}
{$IFDEF MSWINDOWS}
begin
  Result := True;
end;
{$ENDIF}
{$IFDEF ANDROID}
//var
//  ScreenInches2,
//  ScreenInches1,
//  x,y: Double;
//  dm: JDisplayMetrics;
//begin
//  Result := False;
//  dm := GetJDisplayMetrics;
//  if dm = nil then exit;
//  x := dm.widthPixels;
//  y := dm.heightPixels;
//  try
//    ScreenInches1 := Sqrt((x * x / dm.xdpi / dm.xdpi) + (y * y / dm.ydpi / dm.ydpi));
//    ScreenInches2 := Sqr(x * x + y * Y ) / dm.densityDpi;
//  except
//    exit;
//  end;
//  Result := ScreenInches1 >= MiniScreenInches;
//  if Result then
//    Result := ScreenInches2 >= MiniScreenInches;
//end;
var
  IsTablet: Boolean;
begin
  Result := False;
  IsTablet := False;
//  CallInUIThreadAndWaitFinishing(
//  procedure
//  begin
    IsTablet := SharedActivity.getResources.getConfiguration.screenLayout and
      TJConfiguration.JavaClass.SCREENLAYOUT_SIZE_MASK >= TJConfiguration.JavaClass.SCREENLAYOUT_SIZE_LARGE;
//  end);
  Result := IsTablet;
end;
{$ENDIF}

//uses sysutils;

const
  SM_MEDIACENTER = 87;  // Detects XP Media Center Edition
  SM_TABLETPC = 86;     // Detects XP Tablet Edition
  SM_DIGITIZER = 94;
  NID_MULTI_INPUT = $40;

function IsPad: Boolean;
begin
{$IFDEF MSWINDOWS}
begin
  //code by [龟山]Aone(1467948783)
  Result := {TOSVersion.Check(6, 1) and }
               (GetSystemMetrics(SM_TABLETPC) <> 0) and
               ((GetSystemMetrics(SM_DIGITIZER) and NID_MULTI_INPUT) = NID_MULTI_INPUT);
end;
{$ELSE MSWINDOWS}
{$IF DEFINED(IOS) or DEFINED(MACOS)}
{$IFDEF IOS}
begin
  Result := IsPad;
end;
{$ELSE IOS}
begin
  Result := False;
end;
{$ENDIF IOS}
{$ELSE} //IF DEFINED(IOS) or DEFINED(MACOS)
  Result := IsPadOrPC;
{$IFEND IOS or MACOS}
{$ENDIF MSWINDOWS}
end;

function GetTotalMemorySize: UInt64;
{$IF DEFINED(IOS) or DEFINED(MACOS)}
begin
//  Result := TUIDevice2.Wrap(TUIDevice2.OCClass.currentDevice).totalMemory;
  Result := NSRealMemoryAvailable;
end;
{$IFEND}
{$IFDEF MSWINDOWS}
var
  lpBuffer : TMEMORYSTATUS;
begin
  Result := 0;
  ZeroMemory(@lpBuffer, Sizeof(TMEMORYSTATUS));
  lpBuffer.dwLength := Sizeof(TMEMORYSTATUS);
  GlobalMemoryStatus(lpBuffer);
  Result := lpBuffer.dwTotalPhys;
end;
{$ENDIF}
{$IFDEF ANDROID}
var
  Mgr: JActivityManager;
  MgrNative: JObject;
  MemInfo: JActivityManager_MemoryInfo;
  AStrings: TStringList;
  TempValue: string;
  AReader: JReader;
  ABufferedReader: JBufferedReader;
begin
  Result := 0;
  MgrNative :=
{$IF CompilerVersion >= 30.0} // >=RAD10
    TAndroidHelper.Context
{$ELSE}
    SharedActivityContext
{$IFEND}
    .getSystemService(TJContext.JavaClass.ACTIVITY_SERVICE);
  if MgrNative <> nil then
  begin
    Mgr := TJActivityManager.Wrap((MgrNative as ILocalObject).GetObjectID);
    MemInfo := TJActivityManager_MemoryInfo.JavaClass.init;
    Mgr.getMemoryInfo(MemInfo);
    try
      Result := UInt64(MemInfo.totalMem);
    except
      //API level < 16
      try
        Result := UInt64(MemInfo.availMem);
      except
        Result := 0;
      end;
      if FileExists('/proc/meminfo') then
      begin
        AStrings := TStringList.Create;
        try
          AStrings.LineBreak := sLineBreak;
          AStrings.NameValueSeparator := ':';
          AStrings.Clear;
          AReader := TJFileReader.JavaClass.init(StringToJString('/proc/meminfo')) as JReader;
          ABufferedReader := TJBufferedReader.JavaClass.init(AReader);
          repeat
            TempValue := JStringToString(ABufferedReader.readLine);
            if TempValue <> '' then
            begin
              AStrings.Add(TempValue);
            end;
          until (not ABufferedReader.ready);
          ABufferedReader.close;
          TempValue := AStrings.Values['MemTotal'].Trim;
          AStrings.Clear;
          AStrings.NameValueSeparator := ' ';
          AStrings.Add(TempValue.Trim);
          TempValue := AStrings.Names[0];
//          ShowMessage(TempValue);
          Result := StrToInt64Def(TempValue, Result div 1024) * 1024;
        finally
          FreeAndNil(AStrings);
        end;
      end;
    end;
  end;
end;
{$ENDIF}

function GetFreeMemorySize: UInt64;
{$IF DEFINED(IOS) or DEFINED(MACOS)}
begin
  //Result := Max(0, GetTotalMemorySize -
  //  TUIDevice2.Wrap(TUIDevice2.OCClass.currentDevice).userMemory);
  Result := NSRealMemoryAvailable;
end;
{$IFEND}
{$IFDEF MSWINDOWS}
var
  lpBuffer : TMEMORYSTATUS;
begin
  Result := 0;
  ZeroMemory(@lpBuffer, Sizeof(TMEMORYSTATUS));
  lpBuffer.dwLength := Sizeof(TMEMORYSTATUS);
  GlobalMemoryStatus(lpBuffer);
  Result := lpBuffer.dwAvailPhys;
end;
{$ENDIF}
{$IFDEF ANDROID}
var
  Mgr: JActivityManager;
  MgrNative: JObject;
  MemInfo: JActivityManager_MemoryInfo;
begin
  Result := 0;
  MgrNative :=
{$IF CompilerVersion >= 30.0} // >=RAD10
    TAndroidHelper.Context
{$ELSE}
    SharedActivityContext
{$IFEND}
    .getSystemService(TJContext.JavaClass.ACTIVITY_SERVICE);
  if MgrNative <> nil then
  begin
    Mgr := TJActivityManager.Wrap((MgrNative as ILocalObject).GetObjectID);
    MemInfo := TJActivityManager_MemoryInfo.JavaClass.init;
    Mgr.getMemoryInfo(MemInfo);
    try
      Result := UInt64(MemInfo.availMem);
    except
      Result := 0;
    end;
  end;
end;
{$ENDIF}

function GetTotalSpaceSize(Path: string = PathDelim): UInt64;
{$IF DEFINED(IOS) or DEFINED(MACOS)}
var
  Dict: NSDictionary;
  P: Pointer;
const
  FoundationFwk: string = '/System/Library/Frameworks/Foundation.framework/Foundation';
begin
  Result := 0;
  if DirectoryExists(Path) or FileExists(Path) then
  begin
  end
  else
  begin
    raise Exception.Create('Path " ' + Path +  '" not found.');
  end;
  Dict := TNSFileManager.Wrap(TNSFileManager.OCClass.defaultManager).attributesOfFileSystemForPath(NSStr(Path), nil);
  if Dict = nil then
    Exit;
  P := Dict.objectForKey((CocoaNSStringConst(FoundationFwk, 'NSFileSystemSize') as ILocalObject).GetObjectID);
  if P <> nil then
    Result := TNSNumber.Wrap(P).unsignedLongLongValue;
end;
{$IFEND}
{$IFDEF MSWINDOWS}
var
  lpFreeBytesAvailableToCaller,
  lpTotalNumberOfBytes,
  lpTotalNumberOfFreeBytes: Int64;
begin
  Result := 0;
  if DirectoryExists(Path) or FileExists(Path) then
  begin
  end
  else
  begin
    raise Exception.Create('Path " ' + Path +  '" not found.');
  end;
  lpTotalNumberOfBytes := MaxInt;
  if GetDiskFreeSpaceEx(pchar(ExtractFileDrive(Path)),
    lpFreeBytesAvailableToCaller,
    lpTotalNumberOfBytes, @lpTotalNumberOfFreeBytes) then
  begin
    Result := UInt64(lpTotalNumberOfBytes);
  end;
end;
{$ENDIF}
{$IFDEF ANDROID}
var
  AJFile: JFile;
  AJStatFs: JStatFs;
begin
  Result := 0;
  if DirectoryExists(Path) or FileExists(Path) then
  begin
  end
  else
  begin
    raise Exception.Create('Path " ' + Path +  '" not found.');
  end;
  AJFile := TJFile.JavaClass.init(StringToJString(Path));
  if AJFile = nil then exit;
  AJStatFs := TJStatFs.JavaClass.init(AJFile.getPath);
  if AJStatFs = nil then exit;
  Result := UInt64(AJStatFs.getBlockSize) * UInt64(AJStatFs.getBlockCount);
end;
{$ENDIF}

function GetFreeSpaceSize(Path: string = PathDelim): UInt64;
{$IF DEFINED(IOS) or DEFINED(MACOS)}
var
  Dict: NSDictionary;
  P: Pointer;
const
  FoundationFwk: string = '/System/Library/Frameworks/Foundation.framework/Foundation';
begin
  Result := 0;
  if DirectoryExists(Path) or FileExists(Path) then
  begin
  end
  else
  begin
    raise Exception.Create('Path " ' + Path +  '" not found.');
  end;
  Dict := TNSFileManager.Wrap(TNSFileManager.OCClass.defaultManager).attributesOfFileSystemForPath(NSStr(Path), nil);
  if Dict = nil then
    Exit;
  P := Dict.objectForKey((CocoaNSStringConst(FoundationFwk, 'NSFileSystemFreeSize') as ILocalObject).GetObjectID);
  if P <> nil then
    Result := TNSNumber.Wrap(P).unsignedLongLongValue;
end;
{$IFEND}
{$IFDEF MSWINDOWS}
var
  lpFreeBytesAvailableToCaller,
  lpTotalNumberOfBytes,
  lpTotalNumberOfFreeBytes: Int64;
begin
  Result := 0;
  if DirectoryExists(Path) or FileExists(Path) then
  begin
  end
  else
  begin
    raise Exception.Create('Path " ' + Path +  '" not found.');
  end;
  lpTotalNumberOfFreeBytes := MaxInt;
  if GetDiskFreeSpaceEx(pchar(ExtractFileDrive(Path)),
    lpFreeBytesAvailableToCaller,
    lpTotalNumberOfBytes, @lpTotalNumberOfFreeBytes) then
  begin
    Result := UInt64(lpTotalNumberOfFreeBytes);
  end;
end;
{$ENDIF}
{$IFDEF ANDROID}
var
  AJFile: JFile;
  AJStatFs: JStatFs;
begin
  Result := 0;
  if DirectoryExists(Path) or FileExists(Path) then
  begin
  end
  else
  begin
    raise Exception.Create('Path " ' + Path +  '" not found.');
  end;
  AJFile := TJFile.JavaClass.init(StringToJString(Path));
  if AJFile = nil then exit;
  AJStatFs := TJStatFs.JavaClass.init(AJFile.getPath);
  if AJStatFs = nil then exit;
  Result := UInt64(AJStatFs.getBlockSize) * UInt64(AJStatFs.getFreeBlocks);
end;
{$ENDIF}

function GetAvailableSpaceSize(Path: string = PathDelim): UInt64;
{$IF DEFINED(IOS) or DEFINED(MACOS)}
begin
  Result := GetFreeSpaceSize(Path);
end;
{$IFEND}
{$IFDEF MSWINDOWS}
var
  lpFreeBytesAvailableToCaller,
  lpTotalNumberOfBytes,
  lpTotalNumberOfFreeBytes: Int64;
begin
  Result := 0;
  if DirectoryExists(Path) or FileExists(Path) then
  begin
  end
  else
  begin
    raise Exception.Create('Path " ' + Path +  '" not found.');
  end;
  lpFreeBytesAvailableToCaller := MaxInt;
  if GetDiskFreeSpaceEx(pchar(ExtractFileDrive(Path)),
    lpFreeBytesAvailableToCaller,
    lpTotalNumberOfBytes, @lpTotalNumberOfFreeBytes) then
  begin
    Result := UInt64(lpFreeBytesAvailableToCaller);
  end;
end;
{$ENDIF}
{$IFDEF ANDROID}
var
  AJFile: JFile;
  AJStatFs: JStatFs;
begin
  Result := 0;
  if DirectoryExists(Path) or FileExists(Path) then
  begin
  end
  else
  begin
    raise Exception.Create('Path " ' + Path +  '" not found.');
  end;
  AJFile := TJFile.JavaClass.init(StringToJString(Path));
  if AJFile = nil then exit;
    AJStatFs := TJStatFs.JavaClass.init(AJFile.getPath);
  if AJStatFs = nil then exit;
    Result := UInt64(AJStatFs.getBlockSize) * UInt64(AJStatFs.getAvailableBlocks);
end;
{$ENDIF}

{$IFDEF ANDROID}

function CanWriteExterStorage: Boolean;
begin
  Result := False;
  Result := CheckPermission(C_android_permission_EXTERNAL_STORAGE);
//  if Result and TOSVersion.Check(4) then
//  begin
// // 没有效果，而且返回 总是 False
//    Result := CheckPermission(C_android_permission_WRITE_MEDIA);
//  end;
end;

//copy form FMX.AddressBook.Android;
function CheckPermission(const APermissionName: string): Boolean;
var
  PackageName: JString;
begin
  PackageName := TAndroidHelper.Context.getPackageName;
//  if TOSVersion.Check(6) then
//  begin
//    Result := TAndroidHelper.Context.checkSelfPermission(StringToJString(APermissionName)) =
//      TJPackageManager.JavaClass.PERMISSION_GRANTED;
//    exit;
//  end;
  Result := TAndroidHelper.Context.getPackageManager.checkPermission(StringToJString(APermissionName), PackageName) =
    TJPackageManager.JavaClass.PERMISSION_GRANTED;
end;

function isExternalStorageDocument(URI: Jnet_Uri): Boolean;
begin
  Result := False;
  if URI = nil then exit;
  Result := URI.getAuthority.equals(StringToJString('com.android.externalstorage.documents'));
end;

function isDownloadsDocument(URI: Jnet_Uri): Boolean;
begin
  Result := False;
  if URI = nil then exit;
  Result := URI.getAuthority.equals(StringToJString('com.android.providers.downloads.documents'));
end;

function isMediaDocument(URI: Jnet_Uri): Boolean;
begin
  Result := False;
  if URI = nil then exit;
  Result := URI.getAuthority.equals(StringToJString('com.android.providers.media.documents'));
end;

const
  FILE_SELECT_CODE = 0;

var
  FMessageChooserID: Integer = 0;
  FGetFileNameCallBack1: TGetFileNameListener;
  FGetFileNameCallBack2: TGetFileNameLIsternerMethod;

procedure HandleActivityMessageforChooser(const Sender: TObject; const M: TMessage);
var
  MediaDocument,
  ExternalStorageDocument,
  IsOK: Boolean;
  DocType,
  DocIDs,
  FileScheme,
  FileName:string;
  URI: Jnet_Uri;
  cursor: JCursor;
  projection: TJavaObjectArray<JString>;
  column_index: Integer;
  DocIDInfos: TArray<string>;
  TempDocIDStr: JString;
  selection: JString;
  selectionArgs: TJavaObjectArray<JString>;
begin
  IsOK := False;
  FileName := '';
  IsOK := M is TMessageResultNotification;
  if IsOK and (TMessageResultNotification(M).RequestCode = FILE_SELECT_CODE) then
  begin
    IsOK := (TMessageResultNotification(M).ResultCode = TJActivity.JavaClass.RESULT_OK);
  end;
  if IsOK then
  begin
    IsOK := TMessageResultNotification(M).Value <> nil;
  end;
  if IsOK then
  begin
    URI := TMessageResultNotification(M).Value.getData;
    IsOK := URI <> nil;
  end;
  FileName := '';
  if IsOK then
  begin
    FileScheme := JStringToString(URI.getScheme);
    if TOSVersion.Check(4, 4) and TJDocumentsContract.JavaClass.isDocumentUri(
{$IF CompilerVersion >= 30.0} // >=RAD10
      TAndroidHelper.Context
{$ELSE}
      SharedActivityContext
{$IFEND}
      , URI) then
    begin
      //http://blog.csdn.net/u011200844/article/details/43703593
      ExternalStorageDocument := False;
      MediaDocument := False;
      selection := nil;
      selectionArgs := nil;
      IsOK := False;
      if isDownloadsDocument(URI) then
      begin
        TempDocIDStr := TJDocumentsContract.JavaClass.getDocumentId(URI);
        URI := TJContentUris.JavaClass.withAppendedId(
          TJnet_Uri.JavaClass.parse(StringToJString('content://downloads/public_downloads')),
          TJLong.JavaClass.valueOf(TempDocIDStr).longValue);
        //后面会继续处理。
      end
      else
      begin
        ExternalStorageDocument := isExternalStorageDocument(URI);
        if not ExternalStorageDocument then
          MediaDocument := isMediaDocument(URI);
      end;
      if ExternalStorageDocument or MediaDocument then
      begin
        DocIDs := JStringToString(TJDocumentsContract.JavaClass.getDocumentId(URI));
        DocIDInfos := DocIDs.Split([':']);
        if Length(DocIDInfos) > 1 then
        begin
          DocType := DocIDInfos[0];
          if ExternalStorageDocument then
          begin
            if SameText(DocType, 'primary') then
            begin
              FileName := GetSDCardPath(0) + DocIDInfos[1];
              IsOK := True;
            end
            else
            begin
              //后面会继续处理。
            end;
          end
          else if MediaDocument then
          begin
            if SameText(DocType, 'image') then
            begin
              URI := TJImages_Media.JavaClass.EXTERNAL_CONTENT_URI;
              IsOK := True;
            end
            else if SameText(DocType, 'video') then
            begin
              URI := TJVideo_Media.JavaClass.EXTERNAL_CONTENT_URI;
              IsOK := True;
            end
            else if SameText(DocType, 'audio') then
            begin
              URI := TJAudio_Media.JavaClass.EXTERNAL_CONTENT_URI;
              IsOK := True;
            end;
            if IsOK then
            begin
              selection := StringToJString('_id=?');
              selectionArgs := TJavaObjectArray<JString>.Create(1);
              selectionArgs.Items[0] := StringToJString(DocIDInfos[1]);
              IsOK := False;
              //后面会继续处理。
            end;
          end;
        end;
      end;
    end
    else
      IsOK := SameText('file', FileScheme);
  end
  else exit;
  if IsOK and FileName.IsEmpty then
  begin
    FileName := JStringToString(URI.getPath);
  end
  else if not IsOK then       
  begin
    IsOK := SameText('content', FileScheme);
    if IsOK then
    begin
      IsOK := False;
      projection := TJavaObjectArray<JString>.Create(1);
      projection.Items[0] := StringToJString('_data');
      try
        cursor :=
{$IF CompilerVersion >= 30.0} // >=RAD10
          TAndroidHelper.Context
{$ELSE}
          SharedActivityContext
{$IFEND}
          .getContentResolver().query(URI, projection, selection, selectionArgs, nil);
          if (cursor <> nil) then
          begin
            column_index := cursor.getColumnIndexOrThrow(StringToJString('_data'));
            if cursor.moveToFirst then
            begin
              FileName := JStringToString(cursor.getString(column_index));
              IsOK := True;
            end;
          end;
      except
        IsOK := False;
      end;
    end;
//    if not IsOK then
//    begin
//      FileName := JStringToString(URI.getPath);
//      FileName := FileName.Trim;
//      IsOK := not FileName.IsEmpty;
//      if not IsOK then
//      begin
//          IsOK := FileName.IndexOf(PathDelim) <> -1;
//      end;
//      end;
//    end;
  end;
  if IsOK then
  begin
    FileName := FileName.Trim;
    IsOK := not FileName.IsEmpty;
  end;
//  if IsOK then
//  begin
////    IsOK := FileExists(FileName);
//    IsOK := FileName.IndexOf(PathDelim) <> -1;
//  end;
  if Assigned(FGetFileNameCallBack1) then
    FGetFileNameCallBack1(IsOK, FileName);
  if Assigned(FGetFileNameCallBack2) then
    FGetFileNameCallBack2(IsOK, FileName);
end;

function InternalOpenFileDialog(Title, FileExtension:string;
  GetFileNameCallBack1: TGetFileNameListener;
  GetFileNameCallBack2: TGetFileNameLIsternerMethod): Boolean;
var
  MIMEType: JString;
  mime: JMimeTypeMap;
  Intent: JIntent;
  IntentChooser: JIntent;
  sMIMEType: string;
begin
  Result := False;
  FGetFileNameCallBack1 := GetFileNameCallBack1;
  FGetFileNameCallBack2 := GetFileNameCallBack2;
  if FileExtension.Substring(0,1) = '.' then
  begin
    FileExtension := FileExtension.Substring(1);
  end;
  if FileExtension  = '*.*' then
  begin
    FileExtension := '*/*';
  end;
  MIMEType := nil;
  sMIMEType := '';
  if FileExtension = 'file/*' then
  begin
    sMIMEType := 'file/*';
  end
  else if FileExtension = '*' then
  begin
    if TOSVersion.Check(4, 4) then
    begin
      sMIMEType := '*/*';
    end
    else
    begin
      sMIMEType := 'file/*';
    end;
  end
  else if FileExtension = '*/*' then
  begin
    sMIMEType := '*/*';
  end
  else if FileExtension = '' then
  begin
    sMIMEType := '*/*';
  end
  else
  begin
    FileExtension := AnsiLowerCase(FileExtension);
    //http://www.oschina.net/code/snippet_1269559_25060
    mime := TJMimeTypeMap.JavaClass.getSingleton;
    if mime <> nil then
    begin
      MIMEType := mime.getMimeTypeFromExtension(StringToJString(FileExtension));
    end;
  end;
  if MIMEType <> nil then
  begin
    sMIMEType := JStringToString(MIMEType).Trim;
  end;
  if sMIMEType.IsEmpty then
    sMIMEType := '*/*'; // File/* 有时候打不开
  //http://www.cnblogs.com/linlf03/archive/2013/08/19/3267732.html
//  if TOSVersion.Check(4, 4) then
//  begin
//    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_OPEN_DOCUMENT);
//  end
//  else
  begin
    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_GET_CONTENT);
  end;
  Intent.setType(StringToJString(sMIMEType));
  Intent.addCategory(TJIntent.JavaClass.CATEGORY_OPENABLE);
  IntentChooser := TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence(Title));
  if FMessageChooserID <> 0 then
    TMessageManager.DefaultManager.Unsubscribe(TMessageResultNotification, FMessageChooserID);
  FMessageChooserID := 0;
  FMessageChooserID := TMessageManager.DefaultManager.SubscribeToMessage(
    TMessageResultNotification, HandleActivityMessageforChooser);
  try
{$IF CompilerVersion >= 30.0} // >=RAD10
    TAndroidHelper.Activity
{$ELSE}
    SharedActivity
{$IFEND}
    .startActivityForResult(IntentChooser, FILE_SELECT_CODE);
    Result := True;
  except
    raise Exception.Create(Error_NotFoundFileManager_Str);
  end;
end;

function OpenFileDialog(Title, FileExtension:string; GetFileNameCallBack: TGetFileNameListener): Boolean;
begin
  Result := InternalOpenFileDialog(Title, FileExtension, GetFileNameCallBack, nil);
end;

function OpenFileDialog(Title, FileExtension:string; GetFileNameCallBack: TGetFileNameLIsternerMethod): Boolean;
begin
  Result := InternalOpenFileDialog(Title, FileExtension, nil, GetFileNameCallBack);
end;

var
  FExterStoragePath: string = '';
  FInnerStoragePath: string = '';
  FVolumePaths: string = '';
  FSDRegisteredReceiver: Boolean = False;

//type
//  TSDBroadcastListener = class(TJavaLocal, JFMXBroadcastReceiverListener)
//  private
//    //[Weak] FTestObj: TForm1;  //TForm1 是拿来测试，不是必须的。
//  public
//    constructor Create;
//    //看上去，下面的函数属于线程中
//    procedure onReceive(context: JContext; intent: JIntent); cdecl;
//  end;
//
//var
//  //安卓下消息3元素。
//  FSDBroadcastReceiver: JFMXBroadcastReceiver;
//  FSDIntentFilter: JIntentFilter;
//  FSDBroadcastListener: TSDBroadcastListener;
//  //你的 APP 安卓对象。
//  FActivity: JNativeActivity;
//
//
//{ TSDBroadcastListener }
//
//constructor TSDBroadcastListener.Create;
//begin
//  inherited Create;
//  InnerStoragePath := GetSDCardPath(0);
//  ExterStoragePath := GetSDCardPath(1);
//  ExterStoragePathCanRead := False;
//  ExterStoragePathCanWrite := False;
//  SDMountedMessageReceived := False;
//end;
//
//procedure TSDBroadcastListener.onReceive(context: JContext; intent: JIntent);
//var
//  Action,
//  ExternalPath,
//  TempStr1, TempStr2, TempStr3,
//  TempStr: string;
//  AJFile: JFile;
//begin
//  //这里就是处理消息的地方。
//  Action := JStringToString(intent.getAction);
//  TempStr1 := JStringToString(TJIntent.JavaClass.ACTION_MEDIA_MOUNTED);
//  TempStr2 := JStringToString(TJIntent.JavaClass.ACTION_MEDIA_UNMOUNTED);
//  ExternalPath := IncludeTrailingPathDelimiter(GetExternalStoragePath);
//  if SameText(Action, TempStr1) or SameText(Action, TempStr2) then
//  begin
//    TempStr := JStringToString(intent.getData.getPath);// 外置设备路径
//    TempStr := IncludeTrailingPathDelimiter(TempStr);
//    if TOSVersion.Check(5) and SameFileName(TempStr, ExternalPath) then
//    begin
//      //说明内外卡交换了。这是 5.0 的特点。
//      InnerStoragePath := ExterStoragePath;
//      ExterStoragePath := TempStr;
//    end;
//    if SameFileName(TempStr, ExterStoragePath) then
//    begin
//      if SameText(Action, TempStr1) then
//      begin
//        ExterStoragePathCanRead := True;
//        AJFile := TJFile.JavaClass.init(
//          StringToJString(ExcludeTrailingPathDelimiter(TempStr)));
//        if AJFile <> nil then
//        begin
//          ExterStoragePathCanRead := AJFile.canRead;
//          ExterStoragePathCanWrite := AJFile.canWrite;
//        end;
//        SDMountedMessageReceived := True;
//      end;
//    end;
//  end;
//  TempStr1 := JStringToString(TJIntent.JavaClass.ACTION_MEDIA_REMOVED);
//  TempStr2 := JStringToString(TJIntent.JavaClass.ACTION_MEDIA_SHARED);
//  TempStr3 := JStringToString(TJIntent.JavaClass.ACTION_MEDIA_EJECT);
//  if SameText(Action, TempStr1) or
//    SameText(Action, TempStr2) or SameText(Action, TempStr3) then
//  begin
//    TempStr := JStringToString(intent.getData.getPath);// 外置设备路径
//    TempStr := IncludeTrailingPathDelimiter(TempStr);
//    if SameFileName(TempStr, ExterStoragePath) then
//    begin
//      ExterStoragePathCanRead := False;
//      ExterStoragePathCanWrite := False;
//    end;
//  end;
//end;
//
//procedure RegisterSDReceiver;
//begin
//  if FSDRegisteredReceiver then exit;
//  FActivity := TJNativeActivity.Wrap(PANativeActivity(System.DelphiActivity)^.clazz);
//  //FActivity :=
//{$IF CompilerVersion >= 30.0} // >=RAD10
//    TAndroidHelper.Activity
//{$ELSE}
//    SharedActivity
//{$ENDIF};
//  FSDBroadcastListener := TSDBroadcastListener.Create;
//  FSDBroadcastReceiver := TJFMXBroadcastReceiver.JavaClass.init(FSDBroadcastListener);
//
//  //http://blog.csdn.net/yigelangmandeshiren/article/details/8145059
//  FSDIntentFilter := TJIntentFilter.JavaClass.init(TJIntent.JavaClass.ACTION_MEDIA_MOUNTED);
//  FSDIntentFilter.setPriority(1000);// 设置最高优先级
//  FSDIntentFilter.addAction(TJIntent.JavaClass.ACTION_MEDIA_EJECT);
//  FSDIntentFilter.addAction(TJIntent.JavaClass.ACTION_MEDIA_REMOVED);
//  FSDIntentFilter.addAction(TJIntent.JavaClass.ACTION_MEDIA_SHARED);
//  FSDIntentFilter.addAction(TJIntent.JavaClass.ACTION_MEDIA_UNMOUNTED);
//  FSDIntentFilter.addDataScheme(StringToJString('file'));
//
//  //注册消息接收器。别忘了 unregisterReceiver(FBroadcastReceiver);
//  FActivity.registerReceiver(FSDBroadcastReceiver, FSDIntentFilter);
//end;
//
//procedure UnRegisterSDReceiver;
//begin
//  if not FSDRegisteredReceiver then exit;
//  FActivity.unregisterReceiver(FSDBroadcastReceiver);
//  FreeAndNil(FSDBroadcastListener);
//  FSDBroadcastReceiver := nil;
//  FSDIntentFilter := nil;
//  FActivity := nil;
//end;

function GetIsExternalStorageRemovable: Boolean;
begin
  Result := True;
  try
    Result := TJEnvironment.JavaClass.isExternalStorageRemovable;
  except
    //低版本可能发生错误。
  end;
end;

function GetExterStoragePath: string;
//var
//  AJstr: JString;
begin
  if FExterStoragePath.Trim = '' then
  begin
    FExterStoragePath := GetSDCardPath(1);
    if GetIsExternalStorageRemovable then
    begin
      FExterStoragePath := GetSDCardPath(0);
    end;
  end;
  Result := FExterStoragePath.Trim;
  if not DirectoryExists(ExcludeTrailingPathDelimiter(Result)) then
    Result := '';
//  AJstr := TJSystem.JavaClass.getenv(StringToJString('SECONDARY_STORAGE'));
//  if AJstr <> nil then
//    Result := IncludeTrailingPathDelimiter(JStringToString(AJstr));
end;

function GetInnerStoragePath: string;
//var
//  AJstr: JString;
begin
  if FInnerStoragePath.Trim = '' then
  begin
    FInnerStoragePath := GetSDCardPath(0);
    if GetIsExternalStorageRemovable then
    begin
      FInnerStoragePath := GetSDCardPath(1);
    end;
  end;
  Result := FInnerStoragePath.Trim;
  if not DirectoryExists(ExcludeTrailingPathDelimiter(Result)) then
    Result := '';

//  ExterStoragePath := GetSDCardPath(1);
//  AJstr := TJSystem.JavaClass.getenv(StringToJString('EXTERNAL_STORAGE'));
//  if AJstr <> nil then
//    Result := IncludeTrailingPathDelimiter(JStringToString(AJstr));
end;

function GetVolumePaths: string;
var
  Sm: JStorageManager;
  SmNative: JObject;
  AList: TStrings;
  VolumePaths: TJavaObjectArray<JString>;
  I: Integer;
begin
  Result := '';
  if not IsCanFindJavaMethod('getVolumePaths',
    '()[Ljava/lang/String;', 'android/os/storage/StorageManager') then
  begin
    //可以返回点别的。
    exit;
  end;
  Sm := nil;
  SmNative :=
{$IF CompilerVersion >= 30.0} // >=RAD10
    TAndroidHelper.Context
{$ELSE}
    SharedActivityContext
{$IFEND}
    .getSystemService(TJContext.JavaClass.STORAGE_SERVICE);
  if SmNative <> nil then
  begin
    Sm := TJStorageManager.Wrap((SmNative as ILocalObject).GetObjectID);
  end;
  //不打算兼容 2.X 了。
  if (Sm <> nil) and TOSVersion.Check(4) then
  begin
    AList := TStringList.Create;
    try
      try
        VolumePaths := Sm.getVolumePaths;
        for I := 0 to VolumePaths.Length - 1 do
        begin
          AList.Add(JStringToString(VolumePaths.Items[I]));
        end;
      except
      end;
      VolumePaths := nil;
      Result := AList.Text;
      FVolumePaths := Result;
    finally
      FreeAndNil(AList);
    end;
  end;
end;

//function GetActiveMemorySize: UInt64;
//var
//  AStringVs,
//  AStrings: TStringList;
//  TempValue: string;
//  ABufferedReader: JBufferedReader;
//  V1, V2: UInt64;
//begin
//  Result := 0;
//  if FileExists('/proc/meminfo') then
//  begin
//    AStrings := TStringList.Create;
//    AStringVs := TStringList.Create;
//    try
//      AStrings.LineBreak := sLineBreak;
//      AStrings.NameValueSeparator := ':';
//      AStrings.Clear;
//      ABufferedReader := TJBufferedReader.JavaClass.init(
//        JReader(TJFileReader.JavaClass.init(StringToJString('/proc/meminfo'))));
//      repeat
//        TempValue := JStringToString(ABufferedReader.readLine);
//        if TempValue <> '' then
//        begin
//          AStrings.Add(TempValue);
//        end;
//      until (not ABufferedReader.ready);
//      ABufferedReader.close;
//      V1 := 0;
//      TempValue := AStrings.Values['Mapped'].Trim;
//      AStringVs.Clear;
//      AStringVs.NameValueSeparator := ' ';
//      AStringVs.Add(TempValue.Trim);
//      TempValue := AStringVs.Names[0];
//      V2 := StrToInt64Def(TempValue, 0);
//      V1 := V1 + V2;
//      TempValue := AStrings.Values['Inactive'].Trim;
//      AStringVs.Clear;
//      AStringVs.NameValueSeparator := ' ';
//      AStringVs.Add(TempValue.Trim);
//      TempValue := AStringVs.Names[0];
//      V2 := StrToInt64Def(TempValue, 0);
//      V1 := V1 + V2;
//      Result := V1 * 1024;
//    finally
//      FreeAndNil(AStringVs);
//      FreeAndNil(AStrings);
//    end;
//  end;
//  if Result = 0 then
//  begin
//    Result := GetFreeMemorySize;
//  end;
//end;

function GetScreenClientInches: Single;
var
  x,y: Double;
  dm: JDisplayMetrics;
begin
  Result := 3;
  dm := GetJDisplayMetrics;
  if dm = nil then exit;
  x := dm.widthPixels;
  y := dm.heightPixels;
//  x := System.Math.Power(x / dm.xdpi, 2);
//  y := System.Math.Power(y / dm.ydpi, 2);
//  Result := Sqrt(x + y);
  if (dm.densityDpi > dm.xdpi) and (dm.densityDpi > dm.ydpi) then
  begin
    Result := Sqrt(x * x + y * y ) / dm.densityDpi;
  end
  else
  begin
    Result := Sqrt((x * x / dm.xdpi / dm.xdpi) + (y * y / dm.ydpi / dm.ydpi));
  end;
end;

function IsCanFindJavaClass(const NamePath: string): Boolean;
var
  PEnv: PJNIEnv;
{$IF CompilerVersion < 30.0} // < RAD10
  PActivity: PANativeActivity;
{$ELSE}
  ContextClass: JNIClass;
{$IFEND}
  TempClass: JNIClass;
  AMS: MarshaledAString;
begin
  try
    TempClass := nil;
{$IF CompilerVersion < 30.0} // < RAD10
    PActivity := PANativeActivity(System.DelphiActivity);
    PActivity^.vm^.AttachCurrentThread(PActivity^.vm, @PEnv, nil);
{$ELSE}
    PJavaVM(System.JavaMachine)^.AttachCurrentThread(System.JavaMachine, @PEnv, nil);
    ContextClass := nil;
    ContextClass := PEnv^.GetObjectClass(PEnv, System.JavaContext);
{$IFEND}
    AMS := MarshaledAString(Utf8Encode(NamePath.Trim.Replace('.', '/', [rfReplaceAll])));
    try
    TempClass := PEnv^.FindClass(PEnv, AMS);
    PEnv^.ExceptionClear(PEnv);
    Result := TempClass <> nil;
    finally
      if TempClass <> nil then
        PEnv^.DeleteLocalRef(PEnv, TempClass);
{$IF CompilerVersion < 30.0} // < RAD10
{$ELSE}
      if ContextClass <> nil then
        PEnv^.DeleteLocalRef(PEnv, ContextClass);
{$IFEND}
    end;
  except
    Result := False;
  end;
end;

function IsCanFindJavaMethod(const MethodName, Signature: string; const CalssNamePath: string = ''): Boolean;
var
  PEnv: PJNIEnv;
{$IF CompilerVersion < 30.0} // < RAD10
  PActivity: PANativeActivity;
{$ELSE}
  ContextClass: JNIClass;
{$IFEND}
  ActivityClass: JNIClass;
  GetMethod: JNIMethodID;
  ASignature: string;
  AMSMethodName, AMSSignature: MarshaledAString;
begin
  try
    AMSMethodName := MarshaledAString(Utf8Encode(MethodName.Trim));

{$IF CompilerVersion < 30.0} // < RAD10
    PActivity := PANativeActivity(System.DelphiActivity);
    PActivity^.vm^.AttachCurrentThread(PActivity^.vm, @PEnv, nil);
{$ELSE}
    PJavaVM(System.JavaMachine)^.AttachCurrentThread(System.JavaMachine, @PEnv, nil);
    ContextClass := nil;
    ContextClass := PEnv^.GetObjectClass(PEnv, System.JavaContext);
{$IFEND}
    ActivityClass := nil;
    try
      if CalssNamePath.Trim <> '' then
      begin
        ASignature := CalssNamePath.Trim.Replace('.', '/', [rfReplaceAll]);
        AMSSignature := MarshaledAString(Utf8Encode(ASignature));
        ActivityClass := PEnv^.FindClass(PEnv, AMSSignature);
        PEnv^.ExceptionClear(PEnv);
      end
      else
      begin
{$IF CompilerVersion < 30.0} // < RAD10
        ActivityClass := PEnv^.GetObjectClass(PEnv, PActivity^.clazz);
{$ELSE}
        ActivityClass := PEnv^.GetObjectClass(PEnv, System.JavaContext);
{$IFEND}
      end;
      if ActivityClass <> nil then
      begin
        ASignature := Signature.Trim;
        AMSSignature := MarshaledAString(Utf8Encode(ASignature));
        GetMethod := PEnv^.GetMethodID(PEnv, ActivityClass, AMSMethodName, AMSSignature);
        PEnv^.ExceptionClear(PEnv);
        Result := GetMethod <> nil;
      end;
    finally
      if ActivityClass <> nil then
        PEnv^.DeleteLocalRef(PEnv, ActivityClass);
{$IF CompilerVersion < 30.0} // < RAD10
{$ELSE}
      if ContextClass <> nil then
        PEnv^.DeleteLocalRef(PEnv, ContextClass);
{$IFEND}
    end;
  except
    Result := False;
  end;
end;

function IsCanFindJavaStaticMethod(const MethodName, Signature: string; const CalssNamePath: string = ''): Boolean;
var
  PEnv: PJNIEnv;
{$IF CompilerVersion < 30.0} // < RAD10
  PActivity: PANativeActivity;
{$ELSE}
  ContextClass: JNIClass;
{$IFEND}
  ActivityClass: JNIClass;
  GetMethod: JNIMethodID;
  ASignature: string;
  AMSMethodName, AMSSignature: MarshaledAString;
begin
  try
    AMSMethodName := MarshaledAString(Utf8Encode(MethodName.Trim));

{$IF CompilerVersion < 30.0} // < RAD10
    PActivity := PANativeActivity(System.DelphiActivity);
    PActivity^.vm^.AttachCurrentThread(PActivity^.vm, @PEnv, nil);
{$ELSE}
    PJavaVM(System.JavaMachine)^.AttachCurrentThread(System.JavaMachine, @PEnv, nil);
    ContextClass := nil;
    ContextClass := PEnv^.GetObjectClass(PEnv, System.JavaContext);
{$IFEND}
    ActivityClass := nil;
    try
      if CalssNamePath.Trim <> '' then
      begin
        ASignature := CalssNamePath.Trim.Replace('.', '/', [rfReplaceAll]);
        AMSSignature := MarshaledAString(Utf8Encode(ASignature));
        ActivityClass := PEnv^.FindClass(PEnv, AMSSignature);
        PEnv^.ExceptionClear(PEnv);
      end
      else
      begin
{$IF CompilerVersion < 30.0} // < RAD10
        ActivityClass := PEnv^.GetObjectClass(PEnv, PActivity^.clazz);
{$ELSE}
        ActivityClass := PEnv^.GetObjectClass(PEnv, System.JavaContext);
{$IFEND}
      end;
      if ActivityClass <> nil then
      begin
        ASignature := Signature.Trim;
        AMSSignature := MarshaledAString(Utf8Encode(ASignature));
        GetMethod := PEnv^.GetStaticMethodID(PEnv, ActivityClass, AMSMethodName, AMSSignature);
        PEnv^.ExceptionClear(PEnv);
        Result := GetMethod <> nil;
      end;
    finally
      if ActivityClass <> nil then
        PEnv^.DeleteLocalRef(PEnv, ActivityClass);
{$IF CompilerVersion < 30.0} // < RAD10
{$ELSE}
      if ContextClass <> nil then
        PEnv^.DeleteLocalRef(PEnv, ContextClass);
{$IFEND}
    end;
  except
    Result := False;
  end;
end;

procedure UpdateAlbum(FileNames: string);
var
  AJStrList:  TJavaObjectArray<JString>;
  I: Integer;
begin
  With TStringList.Create do
  begin
    try
      Text := FileNames;
      AJStrList := TJavaObjectArray<JString>.Create(Count);
      for I := 0 to Count - 1 do
      begin
        AJStrList.Items[I] := StringToJString(Strings[I]);
      end;
    finally
      Free;
    end;
  end;
  TJMediaScannerConnection.JavaClass.scanFile(TAndroidHelper.Context, AJStrList,
    nil, nil);
end;

function ReadFileToString(const AFileName: string): string;
var
  AReader: JReader;
  ABufferedReader: JBufferedReader;
  TempValue: string;
begin
  Result := '';
  if not FileExists(AFileName) then exit;
  AReader := TJFileReader.JavaClass.init(StringToJString(AFileName)) as JReader;
  ABufferedReader := TJBufferedReader.JavaClass.init(AReader);
  repeat
    TempValue := JStringToString(ABufferedReader.readLine);
    if TempValue <> '' then
    begin
      Result := Result + sLineBreak + TempValue;
    end;
  until (not ABufferedReader.ready);
  ABufferedReader.close;
end;

function ReadNoSizeFileToString(const AFileName: string): string;
begin
  Result := '';
  if not FileExists(AFileName) then exit;
  With TFileStream.Create(AFileName, fmOpenRead) do
  try
    if Size = -1 then exit;
  finally
    Free;
  end;
  Result := ReadFileToString(AFileName);
end;

{$ENDIF}

{$IFDEF ANDROID}

function GetJniPath(MethodName, Signature: MarshaledAString): string;
var
  PEnv: PJniEnv;
  ActivityClass: JNIClass;
  FileClass: JNIClass;
  GetMethod: JNIMethodID;
  GetPathMethod: JNIMethodID;
  PActivity: PANativeActivity;
  StrPathObject: JNIObject;
  FileObject: JNIObject;
begin

  PActivity := PANativeActivity(System.DelphiActivity);
  PActivity^.vm^.AttachCurrentThread(PActivity^.vm, @PEnv, nil);
  ActivityClass := PEnv^.GetObjectClass(PEnv, PActivity^.clazz);

  GetMethod := PEnv^.GetMethodID(PEnv, ActivityClass, MethodName, Signature);
  FileObject := PEnv^.CallObjectMethodA(PEnv, PActivity^.clazz, GetMethod, PJNIValue(ArgsToJNIValues([nil])));
  if FileObject = nil then
    Exit('');
  FileClass := PEnv^.GetObjectClass(PEnv, FileObject);

  GetPathMethod := PEnv^.GetMethodID(PEnv, FileClass, 'getPath', '()Ljava/lang/String;');
  StrPathObject := PEnv^.CallObjectMethodA(PEnv, FileObject, GetPathMethod, PJNIValue(ArgsToJNIValues([])));

  Result := JNIStringToString(PEnv, StrPathObject);

  PEnv^.DeleteLocalRef(PEnv, StrPathObject);
  PEnv^.DeleteLocalRef(PEnv, FileClass);
  PEnv^.DeleteLocalRef(PEnv, FileObject);
  PEnv^.DeleteLocalRef(PEnv, ActivityClass);

end;

function JNIgetExternalStorageDirectory(SubPath: string): string;
begin
//  if SubPath <> '' then
//  begin
//    Result := IncludeTrailingPathDelimiter(
//      GetJniPath('getExternalStorageDirectory', '()Landroid/os/Environment;')
//      ) + SubPath;
//  end
//  else
//  begin
//    Result := GetJniPath('getExternalStorageDirectory', '()Landroid/os/Environment;');
//  end;

  try
    if SubPath <> '' then
    begin
      Result := IncludeTrailingPathDelimiter(JStringToString(
        TJEnvironment.JavaClass.getExternalStorageDirectory.getPath)) + SubPath;
    end
    else
    begin
      Result := JStringToString(TJEnvironment.JavaClass.getExternalStorageDirectory.getPath);
    end;
  except
    //低版本可能发生错误。
  end;
end;

function GetExternalStoragePath: string;
begin
  Result := IncludeTrailingPathDelimiter(JNIgetExternalStorageDirectory(''));
end;

//function isPathCanWrite(const PathOrDir: string; const Default: Boolean = True): Boolean;
//var
//  ADir: string;
//begin
//  Result := False;
//  ADir := ExcludeTrailingPathDelimiter(PathOrDir);
//  if not DirectoryExists(ADir) then exit;
//  Result := True;
//  try
////明明无权限写入，却返回 canWrite 为 True
//    if not TJFile.JavaClass.init(StringToJString(ADir)).canWrite then
//    begin
//      Result := False;
//    end;
//  except
//    Result := False;
//  end;
//end;

function isPathCanUseNow(const PathOrDir: string; const Default: Boolean = True): Boolean;
var
  ADir: string;
begin
  Result := False;
  ADir := ExcludeTrailingPathDelimiter(PathOrDir);
  if not DirectoryExists(ADir) then exit;
  try
//    //下面的代码不能正确的区分内外 SD。
//    Result := TJEnvironment.JavaClass.getExternalStorageState.equals(TJEnvironment.JavaClass.MEDIA_MOUNTED);
//    if GetExterStoragePath.Trim = '' then exit;
    Result := True;
//    if FindJavaMethod('getStorageState',
//      '(Ljava/io/File;)Ljava/lang/String;', 'android/os/Environment') then
//    begin
//      // 这个接口 5.0 会死锁。还是不用了。
//      if not TJEnvironment.JavaClass.getStorageState(
//        TJFile.JavaClass.init(StringToJString(ADir))).equals(
//          TJEnvironment.JavaClass.MEDIA_MOUNTED) then
//      begin
//        Result := False;
//      end;
//    end
//    else
    begin
      if not TJFile.JavaClass.init(StringToJString(ADir)).canRead then
      begin
        Result := False;
      end;
    end;
  except
  end;
end;
{$ELSE}
function isPathCanUseNow(const PathOrDir: string; const Default: Boolean = True): Boolean;
begin
  Result := False;
  if not DirectoryExists(ExcludeTrailingPathDelimiter(PathOrDir)) then exit;
  Result := Default;
end;
{$ENDIF ANDROID}

function TestPathCanWrite(const PathOrDir: string): Boolean;
var
  ATempFile,
  ADir: string;
  AHandle: THandle;
begin
  Result := False;
  ADir := ExcludeTrailingPathDelimiter(PathOrDir);
  if not DirectoryExists(ADir) then exit;
  repeat
    //ATempFile := GetTempFileName;
    try
      if FileExists(ATempFile) then
        //System.IOUtils.TFile.Delete(ATempFile);
    except
    end;
    ATempFile := IncludeTrailingPathDelimiter(ADir) + ExtractFileName(ATempFile);
  until not FileExists(ATempFile);
//  ATempFile := GetTempFileName(ADir);
//  if FileExists(ATempFile) then
//  begin
//    System.IOUtils.TFile.Delete(ATempFile);
//  end;
  try
    AHandle := INVALID_HANDLE_VALUE;
{$IF Defined(MSWINDOWS)}
    AHandle := FileCreate(ATempFile, 0);
{$ELSEIF Defined(POSIX)}
    AHandle := FileCreate(ATempFile, FileAccessRights);
{$IFEND POSIX}
    if AHandle = INVALID_HANDLE_VALUE then
    begin
      Result := False;
    end
    else
    begin
      Result := True;
      FileClose(AHandle);
    end;
  except
    Result := False;
  end;
  if FileExists(ATempFile) then
  begin
    //System.IOUtils.TFile.Delete(ATempFile);
    Result := True;
  end;
end;

//function GetTempFileName(const ATempPath: string): string;
//{$IFDEF MSWINDOWS}
//var
//  ErrCode: UINT;
//begin
//  SetLength(Result, MAX_PATH);
//
//  SetLastError(ERROR_SUCCESS);
//  ErrCode := Winapi.Windows.GetTempFileName(PChar(
//    IncludeTrailingPathDelimiter(ATempPath)
//    ), 'tmp', 0, PChar(Result)); // DO NOT LOCALIZE
//  if ErrCode = 0 then
//    raise EInOutError.Create(SysErrorMessage(GetLastError));
//
//  SetLength(Result, StrLen(PChar(Result)));
//  if FileExists(Result) then
//  begin
//    System.IOUtils.TFile.Delete(Result);
//  end;
//end;
//{$ENDIF}
//{$IFDEF POSIX}
//var
//  LTempPath: TBytes;
//  M: TMarshaller;
//  LRet: MarshaledAString;
//begin
////   char * tempnam(const char *dir, const char *pfx);
//
//  { Obtain a temporary file name }
//  // This code changed from getting the temp name from the temp path via system
//  // to get the temp name inside the specified temp path. We get the system temp path.
////  LTempPath := TEncoding.UTF8.GetBytes(string(tmpnam(nil)));
//  LRet := tempnam(MarshaledAString(M.AsUTF8(
// //返回的路径没有包含 ATempPath
//    IncludeTrailingPathDelimiter(ATempPath)
//    ).ToPointer),nil);
//  LTempPath := TEncoding.UTF8.GetBytes(string(LRet));
//  free(LRet);
//
//  { Convert to UTF16 or leave blank on possible error }
//  if LTempPath <> nil then
//    Result := TEncoding.UTF8.GetString(LTempPath)
//  else
//    Result := '';
//end;
//{$ENDIF POSIX}


{$IFDEF ANDROID}
function FileSystemAttributes(const Path: string): TFileSystemAttributes;
begin
  Result := [fsSymLink, fsCaseSensitive];
//  For android platform we can use the function PathConf on the same way
//  that is used on IOS, but the problem is that for android we only can check
//  _PC_2_SYMLINKS name, and that call is failing on version 2.3.3.

end;
{$ENDIF ANDROID}

function ExpandFileNameCase2(const FileName, RootPath: string; out MatchFound: TFilenameCaseMatch): string;
var
  SR: TSearchRec;
  FullPath, Name: string;
  Status: Integer;
{$IFDEF POSIX}
  FoundOne: Boolean;
  Scans: Byte;
  FirstLetter, TestLetter: string;
{$ENDIF POSIX}
begin
  Result := ExpandFileName(FileName);
  MatchFound := mkNone;

  if FileName = '' then // Stop for empty strings, otherwise we risk to get info infinite loop.
    Exit;

  FullPath := ExtractFilePath(Result);
  Name := ExtractFileName(Result);

  // if FullPath is not the root directory  (portable)
  if not SameFileName(FullPath, IncludeTrailingPathDelimiter(ExtractFileDrive(FullPath))) then
  begin  // Does the path need case-sensitive work?
    Status := FindFirst(ExcludeTrailingPathDelimiter(FullPath), faAnyFile, SR);
    SysUtils.FindClose(SR);   // close search before going recursive
    if Status <> 0 then
    begin
      if SameFileName(IncludeTrailingPathDelimiter(FullPath), IncludeTrailingPathDelimiter(RootPath)) then
      begin
      end
      else
      begin
        FullPath := ExcludeTrailingPathDelimiter(FullPath);
        FullPath := ExpandFileNameCase2(FullPath, RootPath, MatchFound);
        if MatchFound = mkNone then
          Exit;    // if we can't find the path, we certainly can't find the file!
      end;
      FullPath := IncludeTrailingPathDelimiter(FullPath);
    end;
  end;

  // Path is validated / adjusted.  Now for the file itself
  try
    if SysUtils.FindFirst(FullPath + Name, faAnyFile, SR)= 0 then    // exact match on filename
    begin
      if not (MatchFound in [mkSingleMatch, mkAmbiguous]) then  // path might have been inexact
      begin
        if Name = SR.Name then
          MatchFound := mkExactMatch
        else
          MatchFound := mkSingleMatch;
      end;
      //Exit(FullPath + SR.Name);
    end;
  finally
    SysUtils.FindClose(SR);
  end;

{$IFDEF POSIX}
{ Scan the directory.
  To minimize the number of filenames tested, scan the directory
  using upper/lowercase first letter + wildcard.
  This results in two scans of the directory (particularly on Linux) but
  vastly reduces the number of times we have to perform an expensive
  locale-charset case-insensitive string compare.  }

  FoundOne := False;

  if (fsCaseSensitive in FileSystemAttributes(FullPath)) or
     (fsCasePreserving in FileSystemAttributes(FullPath)) then
  begin
    // First, scan for lowercase first letter
    FirstLetter := AnsiLowerCase(Name[Low(string)]);
    for Scans := 0 to 1 do
    begin
      Status := FindFirst(FullPath + FirstLetter + '*', faAnyFile, SR);
      while Status = 0 do
      begin
        if AnsiSameText(SR.Name, Name) then
        begin
          if FoundOne then
          begin  // this is the second match
            MatchFound := mkAmbiguous;
            Exit;
          end
          else
          begin
            FoundOne := True;
            Result := FullPath + SR.Name;
          end;
        end;
        Status := FindNext(SR);
      end;
      FindClose(SR);
      TestLetter := AnsiUpperCase(Name[Low(string)]);
      if TestLetter = FirstLetter then
        Break;
      FirstLetter := TestLetter;
    end;

    if MatchFound <> mkAmbiguous then
    begin
      if FoundOne then
        MatchFound := mkSingleMatch
      else
        MatchFound := mkNone;
    end;
  end;
{$ENDIF POSIX}
end;

function BuildFileListInAPath(const Path: string; const Attr: Integer;
  JustFile: Boolean = False): string;
var
  AList: TStringList;
begin
  Result := '';
  AList := TStringList.Create;
  try
    BuildFileListInAPath(Path, Attr, AList, JustFile);
    Result := AList.Text;
  finally
    FreeAndNil(AList);
  end;
end;

function BuildFileListInAPath(const Path: string; const Attr: Integer; const List: TStrings;
  JustFile: Boolean = False): Boolean;
var
  SearchRec: TSearchRec;
  R: Integer;
begin
  Assert(List <> nil);
  R := SysUtils.FindFirst(ExcludeTrailingPathDelimiter(Path), Attr, SearchRec);
  Result := R = 0;
  try
    if Result then
    begin
      while R = 0 do
      begin
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if ((SearchRec.Attr and faDirectory) = faDirectory) then
          begin
            if not JustFile then
              List.Add(SearchRec.Name);
          end
          else
            List.Add(SearchRec.Name);
        end;
        R := SysUtils.FindNext(SearchRec);
      end;
      Result := R = 0;
    end;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;


(*function faAttrToFileAttributes(
  const Attributes: Integer): TFileAttributes;
begin
{$IFDEF MSWINDOWS}
  Result := [];

  if Attributes and faReadOnly <> 0 then
    Include(Result, TFileAttribute.faReadOnly);
  if Attributes and faHidden <> 0 then
    Include(Result, TFileAttribute.faHidden);
  if Attributes and faSysFile <> 0 then
    Include(Result, TFileAttribute.faSystem);
  if Attributes and faDirectory <> 0 then
    Include(Result, TFileAttribute.faDirectory);
  if Attributes and faArchive <> 0 then
    Include(Result, TFileAttribute.faArchive);
  if Attributes and faSymLink <> 0 then
    Include(Result, TFileAttribute.faSymLink);
  if Attributes and faNormal <> 0 then
    Include(Result, TFileAttribute.faNormal);
  if Attributes and faTemporary <> 0 then
    Include(Result, TFileAttribute.faTemporary);
  if Attributes and faCompressed <> 0 then
    Include(Result, TFileAttribute.faCompressed);
  if Attributes and faEncrypted <> 0 then
    Include(Result, TFileAttribute.faEncrypted);
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  Result := [];
  if Attributes and faDirectory <> 0 then
    Include(Result, TFileAttribute.faDirectory);
  if Attributes and faArchive <> 0 then
    Include(Result, TFileAttribute.faNormal);
  if Attributes and faSymLink <> 0 then
    Include(Result, TFileAttribute.faSymLink);
  if Attributes and faNormal <> 0 then
    Include(Result, TFileAttribute.faNormal);
{$ENDIF POSIX}
end; *)

{$IFDEF MSWINDOWS}
{$ELSE}
//好像不一定有效果。
function FileSetAttr(const FileName: string; Attr: Integer; FollowLink: Boolean = True): Integer;
var
  AFileAttributes: TFileAttributes;
begin
//  Result := faInvalid;
//  AFileAttributes := faAttrToFileAttributes(Attr);
//  TFile.SetAttributes(FileName, AFileAttributes);
  Result := 0;
end;
{$ENDIF MSWINDOWS}

const faInvalid: Integer = $FFFFFFFF;
      faDirectory: Integer = $10;
      faNormal: Integer = $80;
      faReadOnly: Integer = 1;

function DeleteTreeByEcho(const Source: string; AbortOnFailure: Boolean = False;
  YesToAll: Boolean = True;
  WaitMinSecond: Integer = DeleteDirectories_WaitMinSecond): Boolean;
var
  Files: TStringList;
  LPath: string; // writable copy of Path
  FileName: string;
  I: Integer;
  PartialResult: Boolean;
  Attr: Integer;
  isDir: Boolean;
  ToDeleteDir: string;
  T: TDateTime;
  FWaitSecond, FWaitMinSecond: Integer;
begin
  Result := False;
  if not DirectoryExists(ExtractFileDir(Source)) then
  begin
    exit;
  end;
  if Trim(Source) = PathDelim then
  begin
    exit;
  end;
  isDir := DirectoryExists(Source);
  Result := True;
  Files := TStringList.Create;
  try
    if isDir then
    begin
      LPath := IncludeTrailingPathDelimiter(Source);
      ToDeleteDir := LPath + '\*.*';
    end
    else
    begin
      LPath := IncludeTrailingPathDelimiter(ExtractFilePath(Source));
      ToDeleteDir := Source;
    end;
    BuildFileListInAPath(ToDeleteDir, faAnyFile, Files);
    for I := 0 to Files.Count - 1 do
    begin
      FileName := LPath + PathDelim + Files[I];
      PartialResult := True;
      // If the current file is itself a directory then recursively delete it
      Attr := FileGetAttr(FileName);
      if (Attr <> faInvalid) and ((Attr and faDirectory) <> 0) then
      begin
        PartialResult := DeleteTreeByEcho(FileName, AbortOnFailure, YesToAll,
          WaitMinSecond);
      end
      else
      begin
        if YesToAll then
        begin
          // Set attributes to normal in case it's a readonly file
          PartialResult := FileSetAttr(FileName, faNormal) = 0;
        end
        else
        begin
          if ((Attr and faSysFile) <> 0) or ((Attr and faReadOnly) <> 0) or (Attr = faInvalid)
          then
          begin
            PartialResult := False;
          end;
        end;
        if PartialResult then
          PartialResult := SysUtils.DeleteFile(FileName); //TFile.Delete()
      end;
      if not PartialResult then
      begin
        Result := False;
        if AbortOnFailure then
        begin
          Break;
        end;
      end;
    end;
  finally
    FreeAndNil(Files);
  end;
  if Result and isDir then
  begin
    if YesToAll then
    begin
      // Finally remove the directory itself
      Result := FileSetAttr(LPath, faNormal or faDirectory) = 0;
    end
    else
    begin
      Attr := FileGetAttr(LPath);
      if ((Attr and faSysFile) <> 0) or ((Attr and faReadOnly) <> 0) or (Attr = faInvalid) then
      begin
        Result := False;
      end;
    end;
    if Result then
    begin
{$IOCHECKS OFF}
      RmDir(LPath);
      T := Now;
      FWaitSecond := WaitMinSecond div 1000;
      FWaitMinSecond := WaitMinSecond mod 1000;
      while DirectoryExists(LPath) do
      begin
        if T + EncodeTime(0, 0, FWaitSecond, FWaitMinSecond) < now then
        begin
          break;
        end;
        Sleep(1);
      end;
{$IFDEF IOCHECKS_ON}
{$IOCHECKS ON}
{$ENDIF IOCHECKS_ON}
      // Result := IOResult = 0;
      Result := not DirectoryExists(LPath);
      // if not Result then
      // begin
      // ShowMessage(LPath);
      // end;
    end;
  end;
end;

function DeleteDirectoryByEcho(const Source: string;
  AbortOnFailure: Boolean = False; YesToAll: Boolean = True;
  WaitMinSecond: Integer = DeleteDirectories_WaitMinSecond): Boolean;
var
  T: TDateTime;
  FWaitSecond, FWaitMinSecond: Integer;
begin
  Result := False;
  if not DirectoryExists(ExtractFileDir(Source)) then
  begin
    exit;
  end;
  if Trim(Source) = PathDelim then
  begin
    exit;
  end;
  Result := DeleteTreeByEcho(Source, AbortOnFailure, YesToAll, WaitMinSecond);
  if Result then
  begin
    T := Now;
    FWaitSecond := WaitMinSecond div 1000;
    FWaitMinSecond := WaitMinSecond mod 1000;
    while DirectoryExists(Source) do
    begin
      if T + EncodeTime(0, 0, FWaitSecond, FWaitMinSecond) < now then
      begin
        break;
      end;
      Sleep(1);
    end;
  end;
end;

function GetFileNamesFromDirectory(const DirName: string; const SearchFilter: string = '*';
  const FileAttribs: Integer = faAnyFile; const isIncludeSubDirName: Boolean = False; const Recursion: Boolean = False;
  const FullName: Boolean = False): string;
var
  SubList, FileNameList: TStrings;
  DirPath: string;
  SearchRec: TSearchRec;
  i: Integer;
begin
  Result := '';
  if Trim(SearchFilter) = '' then
  begin
    exit;
  end;
  if DirectoryExists(DirName) then
  begin
    FileNameList := TStringList.Create;
    try
      try
        DirPath := IncludeTrailingPathDelimiter(DirName);
        // 得到该目录下指定类型文件的文件名
        if SysUtils.FindFirst(DirPath + Trim(SearchFilter), FileAttribs, SearchRec) = 0 then
        try
          repeat
            if isIncludeSubDirName or ((SearchRec.Attr and faDirectory) <> faDirectory) then
            begin
              if (SearchRec.Attr and faDirectory) = faDirectory then
              begin
                if (ExtractFileName(SearchRec.Name) = '.') or (ExtractFileName(SearchRec.Name) = '..') then
                begin
                  Continue;
                end;
              end;
              if FullName then
              begin
                FileNameList.Add(ExpandFileName(SearchRec.Name));
              end
              else
              begin
                FileNameList.Add(ExtractFileName(SearchRec.Name));
              end;
            end;
          until SysUtils.FindNext(SearchRec) <> 0;
        finally
          SysUtils.FindClose(SearchRec);
        end;

        // 递归该目录下所有子目录下的指定文件。
        if Recursion and (SysUtils.FindFirst(DirPath + '*', faDirectory, SearchRec) = 0) then
        try
          repeat
            if Recursion and ((SearchRec.Attr and faDirectory) = faDirectory) and
              (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
            begin
              Result := GetFileNamesFromDirectory(DirPath + ExtractFileName(SearchRec.Name), SearchFilter,
                FileAttribs, isIncludeSubDirName, Recursion, FullName);
              SubList := TStringList.Create;
              try
                SubList.Clear;
                SubList.Text := Result;
                if not FullName then
                begin
                  for i := 0 to SubList.Count - 1 do
                  begin
                    SubList.Strings[i] := ExtractFileName(SearchRec.Name) + PathDelim + SubList.Strings[i];
                  end;
                end;
                Result := '';
                FileNameList.AddStrings(SubList);
              finally
                FreeAndNil(SubList);
              end;
            end;
          until SysUtils.FindNext(SearchRec) <> 0;
        finally
          SysUtils.FindClose(SearchRec);
        end;
        Result := FileNameList.Text;
      except
        Result := '';
      end;
    finally
      if FileNameList <> nil then
      begin
        FreeAndNil(FileNameList);
      end;
    end;
  end;
end;


function GetCaseSensitiveFileName(const FileName: string; RootPath: string = ''): string;
var
  MatchFound: TFilenameCaseMatch;
begin
  Result := ExpandFileNameCase2(FileName, RootPath, MatchFound);
end;

function GetSDCardPath(Index: Integer = 0): string;
begin
  Result := FindSDCardSubPath('', Index);
end;

function FindSDCardSubPath(SubPath: string; Index: Integer = 0): string;
var
  PathDelimedSubPath: string;
  UnPathDelimedSubPath: string;
{$IFDEF ANDROID}
  VolumePathList: TStrings;
  UsbIndex,
  CdRomIndex,
  TempVolumeIndex,
  I: Integer;
  IsFoundDir0: Boolean;
{$ENDIF ANDROID}
begin
  PathDelimedSubPath := '';
  UnPathDelimedSubPath := SubPath;
  if UnPathDelimedSubPath <> '' then
  begin
    //if UnPathDelimedSubPath.Chars[0] = PathDelim then
    begin
      //UnPathDelimedSubPath := UnPathDelimedSubPath.Substring(1);
    end;
    PathDelimedSubPath := PathDelim + UnPathDelimedSubPath;
  end;
{$IFDEF ANDROID}
  Result := '/storage/emulated/' + IntToStr(Index) + PathDelimedSubPath;
  if FVolumePaths.Trim = '' then GetVolumePaths;
  VolumePathList := TStringList.Create;
  try
    VolumePathList.Text := FVolumePaths;
    if Index = 0 then
    begin
      Result := JNIgetExternalStorageDirectory(UnPathDelimedSubPath);

      if not DirectoryExists(Result) and (VolumePathList.Count > 0) then
      begin
        Result := VolumePathList[0];
      end;

      if not DirectoryExists(Result) then
      begin
        Result := '/storage/emulated/' + IntToStr(Index) + PathDelimedSubPath;
      end;

      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard0' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/sdcard0' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/sdcard' + PathDelimedSubPath;
      end;

      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard_ext0' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard_ext' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/sdcard' + PathDelimedSubPath;
      end;

      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/sdcard_ext0' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/sdcard_ext' + PathDelimedSubPath;
      end;

      if not DirectoryExists(Result) then
      begin
        Result := '/emmc' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/nand' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/flash' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/emmc' + PathDelimedSubPath;
      end;

      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/flash' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/flash' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/D' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/D' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/flash' + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/flash' + PathDelimedSubPath;
      end;

      //last
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard0' + PathDelimedSubPath;
      end;
    end
    else if (Index < UsbDiskStartIndex) then
    begin
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard' + IntToStr(Index) + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard' + IntToStr(Index + 1) + PathDelimedSubPath;
      end;

      if not DirectoryExists(Result) then
      begin
        Result := 'sdcard' + IntToStr(Index) + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := 'sdcard' + IntToStr(Index + 1) + PathDelimedSubPath;
      end;

      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard_ext' + IntToStr(Index) + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard_ext' + IntToStr(Index + 1) + PathDelimedSubPath;
      end;

      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/sdcard' + IntToStr(Index) + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/sdcard' + IntToStr(Index + 1) + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/sdcard_ext' + IntToStr(Index) + PathDelimedSubPath;
      end;
      if not DirectoryExists(Result) then
      begin
        Result := '/mnt/sdcard_ext' + IntToStr(Index + 1) + PathDelimedSubPath;
      end;

      if not DirectoryExists(Result) and (VolumePathList.Count > Index) then
      begin
        Result := VolumePathList[Index];
        if (Result.IndexOf('usbcd') >= 0) or
        (Result.IndexOf('usb') >= 0) or
        (Result.IndexOf('otg') >= 0) or
        (Result.IndexOf('-rw') >= 0) or
        (Result.IndexOf('_rw') >= 0) or
        (Result.IndexOf('cdrom') >= 0) or
        (Result.IndexOf('cd_rom') >= 0) or
        (Result.IndexOf('cd-rom') >= 0) then
        begin
          Result := '';
        end;
      end;

      if Index = 1 then
      begin
        if not DirectoryExists(Result) and (VolumePathList.Count = 2) then
        begin
          Result := VolumePathList[1];
          if (Result.IndexOf('/storage/emulated/') < 0) and
            (Result.IndexOf('/storage/sdcard') < 0) and
            (Result.IndexOf('/mnt/sdcard') < 0) then
          begin
            Result := '';
          end;
        end;

        if not DirectoryExists(Result) then
        begin
          Result := '/storage/extSdCard' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/storage/external1' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/storage/sdcard-ext' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/storage/ext_card' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/storage/extsd' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/storage/_ExternalSD' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/storage/external_sd' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/storage/removable_sdcard' + PathDelimedSubPath;
        end;

        if not DirectoryExists(Result) then
        begin
          Result := '/mnt/extSdCard' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/mnt/external1' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/mnt/sdcard-ext' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/mnt/ext_card' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/mnt/extsd' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/mnt/_ExternalSD' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/mnt/external_sd' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := '/mnt/removable_sdcard' + PathDelimedSubPath;
        end;

        if not DirectoryExists(Result) then
        begin
          Result := 'tflash' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := 'removable_sdcard' + PathDelimedSubPath;
        end;

        if not DirectoryExists(Result) then
        begin
          Result := GetSDCardPath(0) + 'tflash' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := GetSDCardPath(0) + 'extSdCard' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := GetSDCardPath(0) + 'external1' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := GetSDCardPath(0) + 'sdcard-ext' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := GetSDCardPath(0) + 'ext_card' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := GetSDCardPath(0) + 'extsd' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := GetSDCardPath(0) + '_ExternalSD' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := GetSDCardPath(0) + 'external_sd' + PathDelimedSubPath;
        end;
        if not DirectoryExists(Result) then
        begin
          Result := GetSDCardPath(0) + 'removable_sdcard' + PathDelimedSubPath;
        end;
      end;

      //last
      if not DirectoryExists(Result) then
      begin
        Result := '/storage/sdcard' + IntToStr(Index) + PathDelimedSubPath;
      end;
    end
    else if (Index >= UsbDiskStartIndex) and (Index < UsbDiskStartIndex + OTGDeivceCount) then  //UsbDiskStartIndex
    begin
      UsbIndex := Index - UsbDiskStartIndex;
      TempVolumeIndex := UsbIndex;
      Result := '';
      for I := 1 to VolumePathList.Count - 1 do
      begin
        Result := ExcludeTrailingPathDelimiter(VolumePathList[I]);
        if (Result.IndexOf('/storage/usb') < 0) and
          (Result.IndexOf('/storage/otg') < 0) and
          (Result.IndexOf('/mnt/otg') < 0) and
          (Result.IndexOf('/mnt/usb') < 0) then
        begin
          Result := '';
        end
        else if DirectoryExists(Result) then
        begin
          if (Result.IndexOf('usbcd') >= 0) then
          begin
            Result := '';
          end
          else if (Result.IndexOf('otgcd') >= 0) then
          begin
            Result := '';
          end
          else if (TempVolumeIndex = 0) and (Result.Chars[Result.Length] in ['2'..'9']) then
          begin
            Result := '';
          end
          else if (TempVolumeIndex <> 0) and (Result.Chars[Result.Length] <> IntToStr(TempVolumeIndex)) then
          begin
            Result := '';
          end
          else
          begin
            Result := Result + PathDelimedSubPath;
            break;
          end;
        end;
      end;
      if (Result = '') or (not DirectoryExists(Result)) then
      begin
        if UsbIndex = 0 then
        begin
          Result := '/storage/udisk' + PathDelimedSubPath;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/udisk' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'udisk' + PathDelimedSubPath;
          end;


          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbdisk' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbdisk' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbdisk' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbotg' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbotg' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbotg' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbdrive' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbdrive' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbdrive' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usb' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usb' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usb' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/otg' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/otg' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'otg' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'udisk' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'usbotg' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'usb' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'otg' + PathDelimedSubPath;
          end;

          //index = 0
          if not DirectoryExists(Result) then
          begin
            Result := '/storage/udisk0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/udisk0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'udisk0' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbdisk0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbdisk0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbdisk0' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbotg0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbotg0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbotg0' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbdrive0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbdrive0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbdrive0' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usb0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usb0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usb0' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'udisk0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'usbotg0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'usb0' + PathDelimedSubPath;
          end;
        end
        else
        begin
          //index > 0
          IsFoundDir0 := False;
          Result := GetSDCardPath(UsbDiskStartIndex);
          IsFoundDir0 := Result.Chars[Result.Length] = '0';
          if not IsFoundDir0 then
          begin
            inc(TempVolumeIndex);
          end;
          Result := '/storage/udisk' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/udisk' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'udisk' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbdisk' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbdisk' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbdisk' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbotg' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbotg' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbotg' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbdrive' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbdrive' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbdrive' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usb' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usb' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usb' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/otg' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/otg' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'otg' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'udisk' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'usbotg' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'usb' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'otg' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
        end;
      end;

      //last
      if (Result = '') or (not DirectoryExists(Result)) then
      begin
        if UsbIndex = 0 then
        begin
          Result := '/storage/udisk' + PathDelimedSubPath;
        end
        else
        begin
          Result := '/storage/udisk' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
        end;
      end;
    end
    else if (Index >= CDROMStartIndex) and (Index < CDROMStartIndex + OTGDeivceCount) then  //CDROMStartIndex
    begin
      CdRomIndex := Index - CDROMStartIndex;
      TempVolumeIndex := CdRomIndex;
      for I := 1 to VolumePathList.Count - 1 do
      begin
        Result := ExcludeTrailingPathDelimiter(VolumePathList[I]);
        if (Result.IndexOf('/storage/cd') < 0) and
          (Result.IndexOf('/mnt/cd') < 0) and
          (Result.IndexOf('/storage/usbcd') < 0) and
          (Result.IndexOf('/mnt/usbcd') < 0) then
        begin
          Result := '';
        end
        else if DirectoryExists(Result) then
        begin
          if (TempVolumeIndex = 0) and (Result.Chars[Result.Length] in ['2'..'9']) then
          begin
            Result := '';
          end
          else if (TempVolumeIndex <> 0) and (Result.Chars[Result.Length] <> IntToStr(TempVolumeIndex)) then
          begin
            Result := '';
          end
          else
          begin
            Result := Result + PathDelimedSubPath;
            break;
          end;
        end;
      end;
      if (Result = '') or (not DirectoryExists(Result)) then
      begin
        if CdRomIndex = 0 then
        begin
          Result := '/storage/cd-rom' + PathDelimedSubPath;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/cd-rom' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'cd-rom' + PathDelimedSubPath;
          end;

          Result := '/storage/media_rw' + PathDelimedSubPath;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/media_rw' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'media_rw' + PathDelimedSubPath;
          end;

          Result := '/storage/cd_rom' + PathDelimedSubPath;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/cd_rom' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'cd_rom' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbcdrom' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbcdrom' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbcdrom' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/cdrom' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/cdrom' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'cdrom' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'cd-rom' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'usbcdrom' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'cdrom' + PathDelimedSubPath;
          end;

          Result := '/storage/cd-rom' + PathDelimedSubPath;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/cd-rom' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'cd-rom' + PathDelimedSubPath;
          end;

          //index = 0
          if not DirectoryExists(Result) then
          begin
            Result := '/storage/cd_rom0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/cd_rom0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'cd_rom0' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbcdrom0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbcdrom0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbcdrom0' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/cdrom0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/cdrom0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'cdrom0' + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'cd-rom0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'usbcdrom0' + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'cdrom0' + PathDelimedSubPath;
          end;

        end
        else
        begin
          //index > 0
          IsFoundDir0 := False;
          Result := GetSDCardPath(CDROMStartIndex);
          IsFoundDir0 := Result.Chars[Result.Length] = '0';
          if not IsFoundDir0 then
          begin
            inc(TempVolumeIndex);
          end;
          Result := '/storage/cd_rom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/cd_rom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'cd_rom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/usbcdrom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/usbcdrom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'usbcdrom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := '/storage/cdrom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := '/mnt/cdrom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := 'cdrom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;

          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'cd-rom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'usbcdrom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
          if not DirectoryExists(Result) then
          begin
            Result := GetSDCardPath(0) + 'cdrom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
          end;
        end;
      end;

      //last
      if (Result = '') or (not DirectoryExists(Result)) then
      begin
        if CdRomIndex = 0 then
        begin
          Result := '/storage/cd-rom' + PathDelimedSubPath;
        end
        else
        begin
          Result := '/storage/cd-rom' + IntToStr(TempVolumeIndex) + PathDelimedSubPath;
        end;
      end;
    end
    else
    begin
      Result := JNIgetExternalStorageDirectory(UnPathDelimedSubPath);
    end;
  finally
    FreeAndNil(VolumePathList);
  end;
{$ELSE}
  if UnPathDelimedSubPath <> '' then
  begin
    //Result := IncludeTrailingPathDelimiter(
      //IOUtils.TPath.GetSharedDocumentsPath) + UnPathDelimedSubPath;
  end
  else
  begin
    //Result := System.IOUtils.TPath.GetSharedDocumentsPath;
  end;
{$ENDIF ANDROID}
  Result := IncludeTrailingPathDelimiter(Result);
end;

function GetAppPath: string;
begin
{$IF Defined(ANDROID)}
  Result := ExtractFilePath(
    ExcludeTrailingPathDelimiter(
    System.IOUtils.TPath.GetHomePath));
{$ELSE}
  Result := ExtractFilePath(ParamStr(0));
{$IFEND ANDROID}
  Result := IncludeTrailingPathDelimiter(Result);
end;

//initialization
//
//finalization
//  UnRegisterSDReceiver;

end.
