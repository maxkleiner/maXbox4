{***************************************************************************}
{                                                                           }
{           Spring Framework for Delphi                                     }
{                                                                           }
{           Copyright (c) 2009-2012 Spring4D Team - test for mX4 drive      }
{                                                                           }
{           http://www.spring4d.org                                         }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}

///	<summary>
///	  This namespace provides many well-encapsulated utility classes and
///	  routines about the environment and system.
///	</summary>
unit Spring_Utilsmx;


interface

uses
  Classes,
  Windows,
  Messages,
  SysUtils,
  DateUtils,
  StrUtils,
  Variants,
  TypInfo,
  Types,
  ShlObj,
  ShellAPI,
  ActiveX, //SynCommons, //JclWin32,

  ComObj,
  Registry;


  type
    POSVERSIONINFOEXA = ^OSVERSIONINFOEXA;
    _OSVERSIONINFOEXA = record
        dwOSVersionInfoSize: DWORD;
        dwMajorVersion: DWORD;
        dwMinorVersion: DWORD;
        dwBuildNumber: DWORD;
        dwPlatformId: DWORD;
        szCSDVersion: array [0..127] of CHAR;     // Maintenance string for PSS usage
        wServicePackMajor: WORD;
        wServicePackMinor: WORD;
        wSuiteMask: WORD;
        wProductType: BYTE;
        wReserved: BYTE;
    end;
    OSVERSIONINFOEXA = _OSVERSIONINFOEXA;
    LPOSVERSIONINFOEXA = ^OSVERSIONINFOEXA;
    TOSVersionInfoExA = _OSVERSIONINFOEXA;
    TOSVersionInfoEx = TOSVersionInfoExA;




    function GetVersionEx(var lpVersionInformation: TOSVersionInfoEx): BOOL; stdcall;
  external kernel32 name 'GetVersionExA';


  type

  EIOException                  = SysUtils.EInOutError;
  //EFileNotFoundException        = SysUtils.EFileNotFoundException;
  //EDirectoryNotFoundException   = SysUtils.EDirectoryNotFoundException;
  EDriveNotFoundException       = class(EIOException);


  TVersion = record
  private
    const fCUndefined: Integer = -1;
  strict private
    fMajor: Integer;
    fMinor: Integer;
    fBuild: Integer;      // -1 if undefined.
    fReversion: Integer;  // -1 if undefined.
    function GetMajorReversion: Integer;
    function GetMinorReversion: Integer;
  private
    constructor InternalCreate(defined, major, minor, build, reversion: Integer);
    function CompareComponent(a, b: Integer): Integer;
    function IsDefined(const component: Integer): Boolean; inline;
  public
    constructor Create(major, minor: Integer); overload;
    constructor Create(major, minor, build: Integer); overload;
    constructor Create(major, minor, build, reversion: Integer); overload;
    constructor Create(const versionString: string); overload;
    function CompareTo(const version: TVersion): Integer;
    function Equals(const version: TVersion): Boolean;
    function ToString: string; overload;
    function ToString(fieldCount: Integer): string; overload;
    property Major: Integer read fMajor;
    property MajorReversion: integer read GetMajorReversion;
    property Minor: Integer read fMinor;
    property MinorReversion: Integer read GetMinorReversion;
    property Build: Integer read fBuild;
    property Reversion: Integer read fReversion;
    { Operator Overloads }
    {class operator Equal(const left, right: TVersion): Boolean;
    class operator NotEqual(const left, right: TVersion): Boolean;
    class operator GreaterThan(const left, right: TVersion): Boolean;
    class operator GreaterThanOrEqual(const left, right: TVersion): Boolean;
    class operator LessThan(const left, right: TVersion): Boolean;
    class operator LessThanOrEqual(const left, right: TVersion): Boolean;}
  end;


 { type
  POSVersionInfoEx = ^TOSVersionInfoEx;
  TOSVersionInfoEx = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array [0..127] of Char;     // Maintenance string for PSS usage
    wServicePackMajor: Word;
    wServicePackMinor: Word;
    wSuiteMask: Word;
    wProductType: Byte;
    wReserved: Byte;
  end;  }


   // function GetVersionEx; external kernel32 name 'GetVersionExA';




  TFileVersionInfo = record
  private
    type
      TLangAndCodePage = record
        Language: Word;
        CodePage: Word;
      end;

      TLangAndCodePageArray  = array[0..9] of TLangAndCodePage;
      PTLangAndCodePageArray = ^TLangAndCodePageArray;

   TFileVersionResource = record
      private
        fBlock: Pointer;
        fLanguage: Word;
        fCodePage: Word;
      public
        constructor Create(block: Pointer; language, codePage: Word);
        function ReadString(const stringName: string): string;
        property Language: Word read fLanguage;
        property CodePage: Word read fCodePage;
      end;
  strict private
    fExists: Boolean;
    fFileFlags: DWORD;
    fComments: string;
    fCompanyName: string;
    fFileName: string;
    fFileVersion: string;
    fFileVersionNumber: TVersion;
    fFileDescription: string;
    fProductName: string;
    fProductVersion: string;
    fProductVersionNumber: TVersion;
    fInternalName: string;
    fLanguage: string;
    fLegalCopyright: string;
    fLegalTrademarks: string;
    fOriginalFilename: string;
    fPrivateBuild: string;
    fSpecialBuild: string;
    function GetIsDebug: Boolean;
    function GetIsPatched: Boolean;
    function GetIsPreRelease: Boolean;
    function GetIsPrivateBuild: Boolean;
    function GetIsSpecialBuild: Boolean;
  private
    constructor Create(const fileName: string);
    procedure LoadVersionResource(const resource: TFileVersionResource);
  public
    ///	<summary>
    ///	  Gets the file version info of the specified file.
    ///	</summary>
    ///	<exception cref="Spring|EFileNotFoundException">
    ///	  Raised if the file doesn't exist.
    ///	</exception>
    class function GetVersionInfo(const fileName: string): TFileVersionInfo; static;
    function ToString: string;
    property Exists: Boolean read fExists;
    property Comments: string read fComments;
    property CompanyName: string read fCompanyName;
    property FileName: string read fFileName;
    property FileDescription: string read fFileDescription;
    property FileVersion: string read fFileVersion;
    property FileVersionNumber: TVersion read fFileVersionNumber;
    property InternalName: string read fInternalName;
    property Language: string read fLanguage;
    property LegalCopyright: string read fLegalCopyright;
    property LegalTrademarks: string read fLegalTrademarks;
    property OriginalFilename: string read fOriginalFilename;
    property ProductName: string read fProductName;
    property ProductVersion: string read fProductVersion;
    property ProductVersionNumber: TVersion read fProductVersionNumber;
    property PrivateBuild: string read fPrivateBuild;
    property SpecialBuild: string read fSpecialBuild;
    property IsDebug: Boolean read GetIsDebug;
    property IsPatched: Boolean read GetIsPatched;
    property IsPreRelease: Boolean read GetIsPreRelease;
    property IsSpecialBuild: Boolean read GetIsSpecialBuild;
    property IsPrivateBuild: Boolean read GetIsPrivateBuild;
  end;


  TOSPlatformType = (
    ptUnknown,
    ptWin3x,
    ptWin9x,
    ptWinNT
  );

  TOSVersionType = (
    vtUnknown,
    vtWin95,            // DEPRECATED
    vtWin98,            // DEPRECATED
    vtWinME,            // DEPRECATED
    vtWinNT351,         // DEPRECATED
    vtWinNT4,           // DEPRECATED
    vtWinServer2000,
    vtWinXP,
    vtWinServer2003,
    vtWinVista,
    vtWinServer2008,
    vtWin7
  );

  TOSProductType = (
    ptInvalid,
    ptWorkstation,
    ptServer,
    ptDomainController
  );

  TOSSuiteType = (
    etUnknown,
    etWorkStation,
    etServer,
    etAdvancedServer,
    etPersonal,
    etProfessional,
    etDatacenterServer,
    etEnterprise,
    etWebEdition
  );

  TProcessorArchitecture = (
    ///	<summary>
    ///	  Unknown processor
    ///	</summary>
    paUnknown,

    ///	<summary>
    ///	  Intel x86 and compatible microprocessors.
    ///	</summary>
    paX86,

    ///	<summary>
    ///	  64-bit Intel and compatible microprocessors.
    ///	</summary>
    paIA64,

    ///	<summary>
    ///	  64-bit AMD microprocessors.
    ///	</summary>
    paAmd64
  );


    TEnvironmentVariableTarget = (
    ///	<summary>
    ///	  The environment variable is stored or retrieved from the environment
    ///	  block associated with the current process.
    ///	</summary>
    evtProcess,

    ///	<summary>
    ///	  The environment variable is stored or retrieved from the
    ///	  HKEY_CURRENT_USER\Environment key in the Windows operating system
    ///	  registry.
    ///	</summary>
    evtUser,

    ///	<summary>
    ///	  The environment variable is stored or retrieved from the
    ///	  HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session
    ///	  Manager\Environment key in the Windows operating system registry.
    ///	</summary>
    evtMachine
  );




  ///	<summary>
  ///	  Represents information about the operating system.
  ///	</summary>
  TOperatingSystem = class
  private
    fPlatformType: TOSPlatformType;
    fProductType: TOSProductType;
    fServicePack: string;
    fVersion: TVersion;
    fVersionType: TOSVersionType;
    function GetIsWin3x: Boolean;
    function GetIsWin9x: Boolean;
    function GetIsWinNT: Boolean;
    function GetVersionString: string;
  private
    function GetOSVersionType(platformType: TOSPlatformType; productType: TOSProductType;
      majorVersion, minorVersion: Integer): TOSVersionType;
  public
    constructor Create;
    function ToString: string; //override;
    property IsWin3x: Boolean read GetIsWin3x;
    property IsWin9x: Boolean read GetIsWin9x;
    property IsWinNT: Boolean read GetIsWinNT;
    property PlatformType: TOSPlatformType read fPlatformType;
    //property ProductType: TOSProductType read fProductType;
    property ServicePack: string read fServicePack;
    property Version: TVersion read fVersion;
    property VersionString: string read GetVersionString;
    property VersionType: TOSVersionType read fVersionType;
  end;


  TSpecialFolder = (
    sfDesktop,                // <desktop>
    sfInternet,               // Internet Explorer (icon on desktop)
    sfPrograms,               // Start Menu\Programs
    sfControls,               // My Computer\Control Panel
    sfPrinters,               // My Computer\Printers
    sfPersonal,               // My Documents
    sfFavorites,              // <user name>\Favorites
    sfStartup,                // Start Menu\Programs\Startup
    sfRecent,                 // <user name>\Recent
    sfSendTo,                 // <user name>\SendTo
    sfBitBucket,              // <desktop>\Recycle Bin
    sfStartMenu,              // <user name>\Start Menu
    { For Windows >= XP }
    sfMyDocuments,            // logical "My Documents" desktop icon
    sfMyMusic,                // "My Music" folder
    { For Windows >= XP }
    sfMyVideo,                // "My Videos" folder
    sfDesktopDirectory,       // <user name>\Desktop
    sfDrives,                 // My Computer
    sfNetwork,                // Network Neighborhood (My Network Places)
    sfNethood,                // <user name>\nethood
    sfFonts,                  // windows\fonts
    sfTemplates,              // <user name>\Templates
    sfCommonStartMenu,        // All Users\Start Menu
    sfCommonPrograms,         // All Users\Start Menu\Programs
    sfCommonStartup,          // All Users\Startup
    sfCommonDesktopDirectory, // All Users\Desktop
    sfAppData,                // <user name>\Application Data
    sfPrinthood,              // <user name>\PrintHood
    sfLocalAppData,           // <user name>\Local Settings\Applicaiton Data (non roaming)
    sfALTStartup,             // non localized startup
    sfCommonALTStartup,       // non localized common startup
    sfCommonFavorites,        // All Users\Favorites
    sfInternetCache,          // <user name>\Local Settings\Temporary Internet Files
    sfCookies,                // <user name>\Cookies
    sfHistory,                // <user name>\Local Settings\History
    sfCommonAppData,          // All Users\Application Data
    sfWindows,                // GetWindowsDirectory()
    sfSystem,                 // GetSystemDirectory()
    sfProgramFiles,           // C:\Program Files
    sfMyPictures,             // C:\Program Files\My Pictures
    sfProfile,                // USERPROFILE
    sfSystemX86,              // x86 system directory on RISC
    sfProgramFilesX86,        // x86 C:\Program Files on RISC
    sfProgramFilesCommon,     // C:\Program Files\Common
    sfProgramFilesCommonX86,  // x86 Program Files\Common on RISC
    sfCommonTemplates,        // All Users\Templates
    sfCommonDocuments,        // All Users\Documents
    sfCommonAdminTools,       // All Users\Start Menu\Programs\Administrative Tools
    sfAdminTools,             // <user name>\Start Menu\Programs\Administrative Tools
    sfConnections,            // Network and Dial-up Connections
    { For Windows >= XP }
    sfCommonMusic,            // All Users\My Music
    { For Windows >= XP }
    sfCommonPictures,         // All Users\My Pictures
    { For Windows >= XP }
    sfCommonVideo,            // All Users\My Video
    sfResources,              // Resource Direcotry
    sfResourcesLocalized,     // Localized Resource Direcotry
    sfCommonOEMLinks,         // Links to All Users OEM specific apps
    { For Windows >= XP }
    sfCDBurnArea,             // USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning
    sfComputersNearMe         // Computers Near Me (computered from Workgroup membership)
  );

  //TCallbackFunc = TFunc<Pointer>;



  ///	<summary>
  ///	  Provides information about, and means to manipulate, the current
  ///	  environment.
  ///	</summary>
  ///	<remarks>
  ///	  Use the TEnvironment structure to retrieve information such as
  ///	  command-line arguments, environment variable settings.
  ///	</remarks>
  TEnvironmentClass = Class
  private
      fOperatingSystem: TOperatingSystem;
      fApplicationPath: string;
      fApplicationVersionInfo: TFileVersionInfo;
      fApplicationVersion: TVersion;
      fApplicationVersionString: string;
  private

     class function GetCurrentDirectory: string; //static;
     class function GetMachineName: string; //static;
     class function GetIsAdmin: Boolean; //static;
     class function GetUserDomainName: string; //static;
     class function GetUserName: string; //static;
     class function GetTickCount: Cardinal; //static;
     class function GetNewLine: string; //static;
     class function GetUserInteractive: Boolean; //static;
     class function GetCommandLine: string; //static;
     class function GetSystemDirectory: string; //static;
     class function GetProcessorCount: Integer; //static;
     class function GetProcessorArchitecture: TProcessorArchitecture; //static;
     class function GetRegisteredOrganization: string; //static;
     class function GetRegisteredOwner: string; //static;
     class procedure SetCurrentDirectory(const value: string); //static;
  private
     class procedure OpenEnvironmentVariableKey(registry: TRegistry;
      target: TEnvironmentVariableTarget; keyAccess: Cardinal); //static;
     class function GetCurrentVersionKey: string; //static;
     //class procedure GetProcessEnvironmentVariables(list: TStrings); //static;
  public
       constructor Create;
      {$HINTS OFF}
       destructor Destroy;
    ///	<summary>
    ///	  Returns a string array containing the command-line arguments for the
    ///	  current process.
    ///	</summary>
     class function  GetCommandLineArgs: TStringDynArray; overload; //static;

    // TODO: Consider using Extract*** insteading of Get*** for the methods with a
    // TString parameter.

    ///	<summary>
    ///	  Returns a string array containing the command-line arguments for the
    ///	  current process.
    ///	</summary>
   //  class procedure GetCommandLineArgs(list: TStrings); overload; //static;

    ///	<summary>
    ///	  Returns an array of string containing the names of the logical drives
    ///	  on the current computer.
    ///	</summary>
     class function  GetLogicalDrives: TStringDynArray; overload; //static;

//     class procedure GetLogicalDrives(list: TStrings); overload; //static;

    ///	<summary>
    ///	  Gets the path to the system special folder that is identified by the
    ///	  specified enumeration.
    ///	</summary>
     class function  GetFolderPath(const folder: TSpecialFolder): string; //static;

    ///	<summary>
    ///	  Retrieves the value of an environment variable from the current
    ///	  process.
    ///	</summary>
     class function  GetEnvironmentVariable(const variable: string): string; overload; //static;

    ///	<summary>
    ///	  Retrieves the value of an environment variable from the current
    ///	  process or from the Windows operating system registry key for the
    ///	  current user or local machine.
    ///	</summary>
     class function  GetEnvironmentVariable(const variable: string; target: TEnvironmentVariableTarget): string; overload; //static;

    ///	<summary>
    ///	  Retrieves all environment variable names and their values from the
    ///	  current process.
    ///	</summary>
     class procedure GetEnvironmentVariables(list: TStrings); overload; //static;

    ///	<summary>
    ///	  Retrieves the value of an environment variable from the current
    ///	  process or from the Windows operating system registry key for the
    ///	  current user or local machine.
    ///	</summary>
     class procedure GetEnvironmentVariables(list: TStrings; target: TEnvironmentVariableTarget); overload; //static;

    ///	<summary>
    ///	  Creates, modifies, or deletes an environment variable stored in the
    ///	  current process.
    ///	</summary>
     class procedure SetEnvironmentVariable(const variable, value: string); overload; //static;

    ///	<summary>
    ///	  Creates, modifies, or deletes an environment variable stored in the
    ///	  current process or in the Windows operating system registry key
    ///	  reserved for the current user or local machine.
    ///	</summary>
     class procedure SetEnvironmentVariable(const variable, value: string; target: TEnvironmentVariableTarget); overload; //static;

    ///	<summary>
    ///	  Replaces the name of each environment variable embedded in the
    ///	  specified string with the string equivalent of the value of the
    ///	  variable, then returns the resulting string.
    ///	</summary>
     class function ExpandEnvironmentVariables(const variable: string): string; //static;

     property ApplicationPath: string read fApplicationPath;

     property ApplicationVersion: TVersion read fApplicationVersion;

     property ApplicationVersionInfo: TFileVersionInfo read fApplicationVersionInfo;

     property ApplicationVersionString: string read fApplicationVersionString;

    ///	<summary>
    ///	  Gets the command line for this process.
    ///	</summary>
     property CommandLine: string read GetCommandLine;

    ///	<summary>
    ///	  Gets or sets the fully qualified path of the current working
    ///	  directory.
    ///	</summary>
     property CurrentDirectory: string read GetCurrentDirectory write SetCurrentDirectory;

     property IsAdmin: Boolean read GetIsAdmin; { experimental }

    ///	<summary>
    ///	  Gets the NetBIOS name of this local computer.
    ///	</summary>
     property MachineName: string read GetMachineName;

    ///	<summary>
    ///	  Gets the newline string defined for this environment.
    ///	</summary>
     property NewLine: string read GetNewLine;

    ///	<summary>
    ///	  Gets a <see cref="TOperatingSystem" /> object that contains the
    ///	  current platform identifier and version number.
    ///	</summary>
     property OperatingSystem: TOperatingSystem read fOperatingSystem;

    ///	<summary>
    ///	  Gets the number of processors on the current machine.
    ///	</summary>
     property ProcessorCount: Integer read GetProcessorCount;

     property ProcessorArchitecture: TProcessorArchitecture read GetProcessorArchitecture;

     property RegisteredOrganization: string read GetRegisteredOrganization;

     property RegisteredOwner: string read GetRegisteredOwner;

    ///	<summary>
    ///	  Gets the fully qualified path of the system directory.
    ///	</summary>
     property SystemDirectory: string read GetSystemDirectory;

    ///	<summary>
    ///	  Gets the number of milliseconds elapsed since the system started.
    ///	</summary>
     property TickCount: Cardinal read GetTickCount;

    ///	<summary>
    ///	  Gets the network domain name associated with the current user.
    ///	</summary>
     property UserDomainName: string read GetUserDomainName;

    ///	<summary>
    ///	  Gets the user name of the person who is currently logged on to the
    ///	  Windows operating system.
    ///	</summary>
     property UserName: string read GetUserName;

    ///	<summary>
    ///	  Gets a value indicating whether the current process is running in
    ///	  user interactive mode.
    ///	</summary>
     property UserInteractive: Boolean read GetUserInteractive;
  end;

  ///	<summary>
  ///	  Represents a type alias of TEnvironment class.
  ///	</summary>
  Environment = TEnvironmentClass;

  {$ENDREGION}

  ///	<summary>
  ///	  Provides static methods to create various string predicates.
  ///	</summary>



  {$REGION 'Routines'}

  ///	<summary>
  ///	  Returns the path of the application.
  ///	</summary>
  function ApplicationPath: string;

  ///	<summary>
  ///	  Returns the version number of the application.
  ///	</summary>
  function ApplicationVersion: TVersion;

  ///	<summary>
  ///	  Returns the version information of the application.
  ///	</summary>
  function ApplicationVersionString: string;

  ///	<summary>
  ///	  Returns the last system error message.
  ///	</summary>
  function GetLastErrorMessage: string;

  ///	<summary>
  ///	  Creates a standard callback function which was adapted from a instance
  ///	  method.
  ///	</summary>
  ///	<param name="obj">
  ///	  an instance
  ///	</param>
  ///	<param name="methodAddress">
  ///	  address of an instance method
  ///	</param>
  //function CreateCallback(obj: TObject; methodAddress: Pointer): TCallbackFunc;

  ///	<summary>
  ///	  Converts a windows TFiletime value to a delphi TDatetime value.
  ///	</summary>
  function ConvertFileTimeToDateTime(const fileTime: TFileTime; useLocalTimeZone: Boolean): TDateTime; overload;

  function ConvertDateTimeToFileTime(const datetime: TDateTime; useLocalTimeZone: Boolean): TFileTime; overload;

  ///	<summary>
  ///	  Executes a method call within the main thread.
  ///	</summary>
  ///	<param name="threadProc">
  ///	  An anonymous method that will be executed.
  ///	</param>
  ///	<exception cref="EArgumentNullException">
  ///	  Raised if <paramref name="threadProc" /> was not assigned.
  ///	</exception>
  //procedure Synchronize(threadProc: TThreadProcedure);

  ///	<summary>
  ///	  Asynchronously executes a method call within the main thread.
  ///	</summary>
  ///	<param name="threadProc">
  ///	  An anonymous method that will be executed.
  ///	</param>
  ///	<exception cref="EArgumentNullException">
  ///	  Raised if threadProc was not assigned.
  ///	</exception>
  //procedure Queue(threadProc: TThreadProcedure);

  ///	<summary>
  ///	  Try getting property information of an object.
  ///	</summary>
  ///	<returns>
  ///	  Returns true if the instance has the specified property and the
  ///	  property has property information.
  ///	</returns>
  ///	<exception cref="EArgumentNullException">
  ///	  if instance is nil.
  ///	</exception>
  function TryGetPropInfo(instance: TObject; const propertyName: string;
    out propInfo: PPropInfo): Boolean;

  // >>>NOTE<<<
  // Due to the QC #80304, the following methods (with anonymous methods)
  // must not be inlined.

  ///	<summary>
  ///	  Obtains a mutual-exclusion lock for the given object, executes a
  ///	  procedure and then releases the lock.
  ///	</summary>
  ///	<param name="obj">
  ///	  the sync root.
  ///	</param>
  ///	<param name="proc">
  ///	  the procedure that will be invoked.
  ///	</param>
  ///	<exception cref="Spring|EArgumentNullException">
  ///	  Raised if <paramref name="obj" /> is nil or <paramref name="proc" /> is
  ///	  unassigned.
  ///	</exception>
  //procedure Lock(obj: TObject; const proc: TProc); overload; // inline;
 // procedure Lock(const intf: IInterface; const proc: TProc); overload; // inline;

  ///	<summary>
  ///	  Updates an instance of <see cref="Classes|TStrings" /> by calling its
  ///	  BeginUpdate and EndUpdate.
  ///	</summary>
  ///	<param name="strings">
  ///	  an instance of TStrings.
  ///	</param>
  ///	<exception cref="EArgumentNullException">
  ///	  Raised if <paramref name="strings" /> is nil or <paramref name="proc" />
  ///	  is not assigned.
  ///	</exception>
  //procedure UpdateStrings(strings: TStrings; proc: TProc); // inline;

  ///	<summary>
  ///	  Returns True if the Control key is pressed, otherwise false.
  ///	</summary>
  function IsCtrlPressed: Boolean;

  ///	<summary>
  ///	  Returns True if the Shift key is pressed, otherwise false.
  ///	</summary>
  function IsShiftPressed: Boolean;

  ///	<summary>
  ///	  Returns True if the Alt key is pressed, otherwise false.
  ///	</summary>
  function IsAltPressed: Boolean;

  {$REGION 'XML Documentation'}
  {$ENDREGION}

  ///	<summary>
  ///	  Determines whether a specified file exists. An
  ///	  <see cref="EFileNotFoundException" /> exception will be raised when not
  ///	  found.
  ///	</summary>
  ///	<param name="fileName">
  ///	  the file name.
  ///	</param>
  ///	<exception cref="EFileNotFoundException">
  ///	  Raised if the target file does not exist.
  ///	</exception>
  ///	<seealso cref="CheckDirectoryExists(string)" />
  procedure CheckFileExists(const fileName: string);

  ///	<summary>
  ///	  Determines whether a specified directory exists. An
  ///	  <see cref="EDirectoryNotFoundException" /> exception will be raised
  ///	  when not found.
  ///	</summary>
  ///	<exception cref="EDirectoryNotFoundException">
  ///	  Raised if the directory doesn't exist.
  ///	</exception>
  ///	<seealso cref="CheckFileExists(string)" />
  procedure CheckDirectoryExists(const directory: string);


  function TryConvertStrToDateTime(const s, format: string; out value: TDateTime): Boolean;

///	<summary>
///	  Parses a string to a datetime value based on the specified format. An
///	  EConvertError exception will be raised if failed to parse the string.
///	</summary>
///	<param name="s">
///	  the date time string.
///	</param>
///	<param name="format">
///	  the format of datetime.
///	</param>
///
///
///

type   TCharArray = array of char;
function ConvertStrToDateTime(const s, format: string): TDateTime;

 function SplitString(const buffer: string; const separators: TSysCharSet;
  removeEmptyEntries: Boolean = False): TStringDynArray; overload;
function SplitString(const buffer: TCharArray; const separators: TSysCharSet;
  removeEmptyEntries: Boolean = False): TStringDynArray; overload;
function SplitString(const buffer: PChar; len: Integer; const separators: TSysCharSet;
  removeEmptyEntries: Boolean = False): TStringDynArray; overload;
function SplitString(const buffer: PChar): TStringDynArray; overload;


  {$ENDREGION}


  {$REGION 'Constants'}

const
  ///	<summary>
  ///	  Represents bytes of one KB.
  ///	</summary>
  COneKB: Int64 = 1024;            // 1KB = 1024 bytes


  ///	<summary>
  ///	  Represents bytes of one MB.
  ///	</summary>
  COneMB: Int64 = 1048576;         // 1MB = 1024 KB

  ///	<summary>
  ///	  Represents bytes of one GB.
  ///	</summary>
  COneGB: Int64 = 1073741824;      // 1GB = 1024 MB

  ///	<summary>
  ///	  Represents bytes of one TB.
  ///	</summary>
  COneTB: Int64 = 1099511627776;   // 1TB = 1024 GB

  ///	<summary>
  ///	  Represents bytes of one KB.
  ///	</summary>
  OneKB: Int64 = 1024;// deprecated 'Use COneKB instead.';

  ///	<summary>
  ///	  Represents bytes of one MB.
  ///	</summary>
  OneMB: Int64 = 1048576;// deprecated 'Use COneMB instead.';

  ///	<summary>
  ///	  Represents bytes of one GB.
  ///	</summary>
  OneGB: Int64 = 1073741824;// deprecated 'Use COneGB instead.';

  ///	<summary>
  ///	  Represents bytes of one TB.
  ///	</summary>
  OneTB: Int64 = 1099511627776;// deprecated 'Use COneTB instead.';

  const
    SpecialFolderCSIDLs: array[TSpecialFolder] of Integer = (
      CSIDL_DESKTOP,                  // <desktop>
      CSIDL_INTERNET,                 // Internet Explorer (icon on desktop)
      CSIDL_PROGRAMS,                 // Start Menu\Programs
      CSIDL_CONTROLS,                 // My Computer\Control Panel
      CSIDL_PRINTERS,                 // My Computer\Printers
      CSIDL_PERSONAL,                 // My Documents.  This is equivalent to CSIDL_MYDOCUMENTS in XP and above
      CSIDL_FAVORITES,                // <user name>\Favorites
      CSIDL_STARTUP,                  // Start Menu\Programs\Startup
      CSIDL_RECENT,                   // <user name>\Recent
      CSIDL_SENDTO,                   // <user name>\SendTo
      CSIDL_BITBUCKET,                // <desktop>\Recycle Bin
      CSIDL_STARTMENU,                // <user name>\Start Menu
      CSIDL_MYDOCUMENTS,              // logical "My Documents" desktop icon
      CSIDL_MYMUSIC,                  // "My Music" folder
      CSIDL_MYVIDEO,                  // "My Video" folder
      CSIDL_DESKTOPDIRECTORY,         // <user name>\Desktop
      CSIDL_DRIVES,                   // My Computer
      CSIDL_NETWORK,                  // Network Neighborhood (My Network Places)
      CSIDL_NETHOOD,                  // <user name>\nethood
      CSIDL_FONTS,                    // windows\fonts
      CSIDL_TEMPLATES,
      CSIDL_COMMON_STARTMENU,         // All Users\Start Menu
      CSIDL_COMMON_PROGRAMS,          // All Users\Start Menu\Programs
      CSIDL_COMMON_STARTUP,           // All Users\Startup
      CSIDL_COMMON_DESKTOPDIRECTORY,  // All Users\Desktop
      CSIDL_APPDATA,                  // <user name>\Application Data
      CSIDL_PRINTHOOD,                // <user name>\PrintHood
      CSIDL_LOCAL_APPDATA,            // <user name>\Local Settings\Application Data (non roaming)
      CSIDL_ALTSTARTUP,               // non localized startup
      CSIDL_COMMON_ALTSTARTUP,        // non localized common startup
      CSIDL_COMMON_FAVORITES,
      CSIDL_INTERNET_CACHE,
      CSIDL_COOKIES,
      CSIDL_HISTORY,
      CSIDL_COMMON_APPDATA,           // All Users\Application Data
      CSIDL_WINDOWS,                  // GetWindowsDirectory()
      CSIDL_SYSTEM,                   // GetSystemDirectory()
      CSIDL_PROGRAM_FILES,            // C:\Program Files
      CSIDL_MYPICTURES,               // C:\Program Files\My Pictures
      CSIDL_PROFILE,                  // USERPROFILE
      CSIDL_SYSTEMX86,                // x86 system directory on RISC
      CSIDL_PROGRAM_FILESX86,         // x86 C:\Program Files on RISC
      CSIDL_PROGRAM_FILES_COMMON,     // C:\Program Files\Common
      CSIDL_PROGRAM_FILES_COMMONX86,  // x86 C:\Program Files\Common on RISC
      CSIDL_COMMON_TEMPLATES,         // All Users\Templates
      CSIDL_COMMON_DOCUMENTS,         // All Users\Documents
      CSIDL_COMMON_ADMINTOOLS,        // All Users\Start Menu\Programs\Administrative Tools
      CSIDL_ADMINTOOLS,               // <user name>\Start Menu\Programs\Administrative Tools
      CSIDL_CONNECTIONS,              // Network and Dial-up Connections
      CSIDL_COMMON_MUSIC,             // All Users\My Music
      CSIDL_COMMON_PICTURES,          // All Users\My Pictures
      CSIDL_COMMON_VIDEO,             // All Users\My Video
      CSIDL_RESOURCES,                // Resource Directory
      CSIDL_RESOURCES_LOCALIZED,      // Localized Resource Directory
      CSIDL_COMMON_OEM_LINKS,         // Links to All Users OEM specific apps
      CSIDL_CDBURN_AREA,              // USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning
      CSIDL_COMPUTERSNEARME           // Computers Near Me (computered from Workgroup membership)
    );

  {$ENDREGION}

implementation

uses
  Math;
  //Spring.ResourceStrings;


const

 SDriveNotReady              = 'Drive "%S" is not ready.';

  SUnknownDriveDescription    = 'Unknown Drive';
  SNoRootDirectoryDescription = 'No Root Directory';
  SRemovableDescription       = 'Removable Drive';
  SFixedDescription           = 'Fixed Drive';
  SNetworkDescription         = 'Network Drive';
  SCDRomDescription           = 'CD-Rom Drive';
  SRamDescription             = 'Ram Drive';

  SUnknownOSDescription      = 'Unknown Operating System';
  SWin95Description          = 'Microsoft Windows 95';
  SWin98Description          = 'Microsoft Windows 98';
  SWinMEDescription          = 'Microsoft Windows ME';
  SWinNT351Description       = 'Microsoft Windows NT 3.51';
  SWinNT40Description        = 'Microsoft Windows NT 4';
  SWinServer2000Description  = 'Microsoft Windows Server 2000';
  SWinXPDescription          = 'Microsoft Windows XP';
  SWinServer2003Description  = 'Microsoft Windows Server 2003';
  SWinVistaDescription       = 'Microsoft Windows Vista';
  SWinServer2008Description  = 'Microsoft Windows Server 2008';
  SWin7Description           = 'Microsoft Windows 7';

 resourcestring
   SInvalidDateTime     = '"%S" is not a valid date and time.';
    SFileNotFoundException          = 'File not found: %s';
  SDirectoryNotFoundException     = 'Directory not found: %s';
  SNullableTypeHasNoValue         = 'Invalid operation, Nullable type has no value.';
   SCannotAccessRegistryKey     = 'Cannot access the registry key: %s.';

  SAbstractClassCreation       = 'Cannot create the abstract class: %s.';




  SFileVersionInfoFormat =
    'File:             %s' + #13#10 +
    'InternalName:     %s' + #13#10 +
    'OriginalFilename: %s' + #13#10 +
    'FileVersion:      %s' + #13#10 +
    'FileDescription:  %s' + #13#10 +
    'Product:          %s' + #13#10 +
    'ProductVersion:   %s' + #13#10 +
    'Debug:            %s' + #13#10 +
    'Patched:          %s' + #13#10 +
    'PreRelease:       %s' + #13#10 +
    'PrivateBuild:     %s' + #13#10 +
    'SpecialBuild:     %s' + #13#10 +
    'Language:         %s' + #13#10;


  SAtLeastTwoElements = 'There must be at least two elements.';
  SIllegalArgumentQuantity = 'Invalid argument "quantity": %d.';

  SInvalidOperationCurrent = 'Invalid operation. The enumerable collection is empty.';

   

const
  OSVersionTypeStrings: array[TOSVersionType] of string = (
    SUnknownOSDescription,
    SWin95Description,
    SWin98Description,
    SWinMEDescription,
    SWinNT351Description,
    SWinNT40Description,
    SWinServer2000Description,
    SWinXPDescription,
    SWinServer2003Description,
    SWinVistaDescription,
    SWinServer2008Description,
    SWin7Description
  );


  { TFileVersionInfo.TFileVersionData }

constructor TFileVersionInfo.TFileVersionResource.Create(block: Pointer;
  language, codePage: Word);
begin
  fBlock := block;
  fLanguage := language;
  fCodePage := codePage;
end;

function TFileVersionInfo.TFileVersionResource.ReadString(
  const stringName: string): string;
var
  subBlock: string;
  data: PChar;
  len: Cardinal;
const
  SubBlockFormat = '\StringFileInfo\%4.4x%4.4x\%s';   // do not localize
begin
  subBlock := Format(
    SubBlockFormat,
    [fLanguage, fCodePage, stringName]
  );
  data := nil;
  len := 0;
  VerQueryValue(fBlock, PChar(subBlock), Pointer(data), len);
  Result := data;
end;


function TFileVersionInfo.GetIsDebug: Boolean;
begin
  Result := (fFileFlags and VS_FF_DEBUG) <> 0;
end;

function TFileVersionInfo.GetIsPatched: Boolean;
begin
  Result := (fFileFlags and VS_FF_PATCHED) <> 0;
end;

function TFileVersionInfo.GetIsPreRelease: Boolean;
begin
  Result := (fFileFlags and VS_FF_PRERELEASE) <> 0;
end;

function TFileVersionInfo.GetIsPrivateBuild: Boolean;
begin
  Result := (fFileFlags and VS_FF_PRIVATEBUILD) <> 0;
end;

function TFileVersionInfo.GetIsSpecialBuild: Boolean;
begin
  Result := (fFileFlags and VS_FF_SPECIALBUILD) <> 0;
end;


constructor TFileVersionInfo.Create(const fileName: string);
var
  block: Pointer;
  fixedFileInfo: PVSFixedFileInfo;
  translations: PTLangAndCodePageArray;
  size: DWORD;
  valueSize: DWORD;
  translationSize: Cardinal;
  translationCount: Integer;
  dummy: DWORD;
begin
  Finalize(Self);
  ZeroMemory(@Self, SizeOf(Self));
  fFileName := fileName;
  CheckFileExists(fFileName);
  // GetFileVersionInfo modifies the filename parameter data while parsing.
  // Copy the string const into a local variable to create a writeable copy.
  UniqueString(fFileName);
  size := GetFileVersionInfoSize(PChar(fFileName), dummy);
  fExists := size <> 0;
  if fExists then
  begin
    block := AllocMem(size);
    try
      Win32Check(Windows.GetFileVersionInfo(
        PChar(fFileName),
        0,
        size,
        block
      ));
      Win32Check(VerQueryValue(
        block,
        '\',
        Pointer(fixedFileInfo),
        valueSize
      ));
      Win32Check(VerQueryValue(
        block,
        '\VarFileInfo\Translation',
        Pointer(translations),
        translationSize
      ));
      fFileVersionNumber := TVersion.Create(
        HiWord(fixedFileInfo.dwFileVersionMS),
        LoWord(fixedFileInfo.dwFileVersionMS),
        HiWord(fixedFileInfo.dwFileVersionLS),
        LoWord(fixedFileInfo.dwFileVersionLS)
      );
      fProductVersionNumber := TVersion.Create(
        HiWord(fixedFileInfo.dwProductVersionMS),
        LoWord(fixedFileInfo.dwProductVersionMS),
        HiWord(fixedFileInfo.dwProductVersionLS),
        LoWord(fixedFileInfo.dwProductVersionLS)
      );
      fFileFlags := fixedFileInfo.dwFileFlags;
      translationCount := translationSize div SizeOf(TLangAndCodePage);
      if translationCount > 0 then
      begin
        LoadVersionResource(
          TFileVersionResource.Create(
            block,
            translations[0].Language,
            translations[0].CodePage
          )
        );
      end;
    finally
      FreeMem(block);
    end;
  end;
end;

class function TFileVersionInfo.GetVersionInfo(
  const fileName: string): TFileVersionInfo;
var
  localFileName: string;
begin
  localFileName := Environment.ExpandEnvironmentVariables(fileName);
  Result := TFileVersionInfo.Create(localFileName);
end;

procedure TFileVersionInfo.LoadVersionResource(const resource: TFileVersionResource);
begin
  fCompanyName := resource.ReadString('CompanyName');
  fFileDescription := resource.ReadString('FileDescription');
  fFileVersion := resource.ReadString('FileVersion');
  fInternalName := resource.ReadString('InternalName');
  fLegalCopyright := resource.ReadString('LegalCopyright');
  fLegalTrademarks := resource.ReadString('LegalTrademarks');
  fOriginalFilename := resource.ReadString('OriginalFilename');
  fProductName := resource.ReadString('ProductName');
  fProductVersion := resource.ReadString('ProductVersion');
  fComments := resource.ReadString('Comments');
  fLanguage := Languages.NameFromLocaleID[resource.Language];
end;

function TFileVersionInfo.ToString: string;
begin
  Result := Format(SFileVersionInfoFormat, [
    FileName,
    InternalName,
    OriginalFilename,
    FileVersion,
    FileDescription,
    ProductName,
    ProductVersion,
    BoolToStr(IsDebug, True),
    BoolToStr(IsPatched, True),
    BoolToStr(IsPreRelease, True),
    BoolToStr(IsPrivateBuild, True),
    BoolToStr(IsSpecialBuild, True),
    Language
  ]);
end;


{ TFileVersionInfo.TFileVersionData }

{constructor TFileVersionInfo.TFileVersionResource.Create(block: Pointer;
  language, codePage: Word);
begin
  fBlock := block;
  fLanguage := language;
  fCodePage := codePage;
end;}

{function TFileVersionInfo.TFileVersionResource.ReadString(
  const stringName: string): string;
var
  subBlock: string;
  data: PChar;
  len: Cardinal;
const
  SubBlockFormat = '\StringFileInfo\%4.4x%4.4x\%s';   // do not localize
begin
  subBlock := Format(
    SubBlockFormat,
    [fLanguage, fCodePage, stringName]
  );
  data := nil;
  len := 0;
  VerQueryValue(fBlock, PChar(subBlock), Pointer(data), len);
  Result := data;
end;  }




{$REGION 'Routines'}

function ApplicationPath: string;
begin
  //Result := TEnvironmentClass.ApplicationPath;
  //  Result := environment.ApplicationPath;

  end;

function ApplicationVersion: TVersion;
begin
  //Result := TEnvironment.ApplicationVersion;
end;

function ApplicationVersionString: string;
begin
  //Result := TEnvironment.ApplicationVersionString;
end;

function GetLastErrorMessage: string;
begin
  Result := SysErrorMessage(GetLastError);
end;

{function CreateCallback(obj: TObject; methodAddress: Pointer): TCallbackFunc;
begin
  TArgument.CheckNotNull(obj, 'obj');
  TArgument.CheckNotNull(methodAddress, 'methodAddress');
  Result := TCallback.Create(obj, methodAddress);
end;}

function ConvertFileTimeToDateTime(const fileTime: TFileTime; useLocalTimeZone: Boolean): TDateTime;
var
  localFileTime: TFileTime;
  systemTime: TSystemTime;
begin
  if useLocalTimeZone then
  begin
    FileTimeToLocalFileTime(fileTime, localFileTime);
  end
  else
  begin
    localFileTime := fileTime;
  end;
  if FileTimeToSystemTime(localFileTime, systemTime) then
  begin
    Result := SystemTimeToDateTime(systemTime);
  end
  else
  begin
    Result := 0;
  end;
end;

function ConvertDateTimeToFileTime(const datetime: TDateTime;
  useLocalTimeZone: Boolean): TFileTime;
var
  systemTime: TSystemTime;
  fileTime: TFileTime;
begin
  Result.dwLowDateTime := 0;
  Result.dwHighDateTime := 0;
  DateTimeToSystemTime(datetime, systemTime);
  if SystemTimeToFileTime(systemTime, fileTime) then
  begin
    if useLocalTimeZone then
    begin
      LocalFileTimeToFileTime(fileTime, Result);
    end
    else
    begin
      Result := fileTime;
    end;
  end;
end;

{procedure Synchronize(threadProc: TThreadProcedure);
begin
  TArgument.CheckNotNull(Assigned(threadProc), 'threadProc');
  TThread.Synchronize(TThread.CurrentThread, threadProc);
end;

procedure Queue(threadProc: TThreadProcedure);
begin
  TArgument.CheckNotNull(Assigned(threadProc), 'threadProc');
  TThread.Queue(TThread.CurrentThread, threadProc);
end; }

function TryGetPropInfo(instance: TObject; const propertyName: string;
  out propInfo: PPropInfo): Boolean;
begin
  //TArgument.CheckNotNull(instance, 'instance');
  propInfo := GetPropInfo(instance, propertyName);
  Result := propInfo <> nil;
end;

 function TryConvertStrToDateTime(const s, format: string; out value: TDateTime): Boolean;
var
  localString: string;
  stringFormat: string;
  year, month, day: Word;
  hour, minute, second, milliSecond: Word;

  function ExtractElementDef(const element: string; const defaultValue: Integer = 0): Integer;
  var
    position: Integer;
  begin
    position := Pos(element, stringFormat);
    if position > 0 then
    begin
      Result := StrToInt(Copy(localString, position, Length(element)));
    end
    else
    begin
      Result := defaultValue;
    end;
  end;
begin
  localString := Trim(s);
  stringFormat := UpperCase(format);
  Result := Length(localString) = Length(stringFormat);
  if Result then
  try
    year := ExtractElementDef('YYYY', 0);
    if year = 0 then
    begin
      year := ExtractElementDef('YY', 1899);
      if year < 1899 then
      begin
        Inc(year, (DateUtils.YearOf(Today) div 100) * 100);
      end;
    end;
    month := ExtractElementDef('MM', 12);
    day := ExtractElementDef('DD', 30);
    hour := ExtractElementDef('HH');
    minute := ExtractElementDef('NN');
    second := ExtractElementDef('SS');
    milliSecond := ExtractElementDef('ZZZ');
    value := EncodeDateTime(year, month, day, hour, minute, second, milliSecond);
  except
    Result := False;
  end;
end;

function ConvertStrToDateTime(const s, format: string): TDateTime;
begin
  if not TryConvertStrToDateTime(s, format, Result) then
  begin
    raise EConvertError.CreateResFmt(@SInvalidDateTime, [s]);
  end;
end;



function TryParseDateTime(const s, format: string; out value: TDateTime): Boolean;
begin
  Result := TryConvertStrToDateTime(s, format, value);
end;

function ParseDateTime(const s, format: string): TDateTime;
begin
  Result := ConvertStrToDateTime(s, format);
end;

{procedure Lock(obj: TObject; const proc: TProc);
begin
  //TArgument.CheckNotNull(obj, 'obj');
  //TArgument.CheckNotNull(Assigned(proc), 'proc');

  System.MonitorEnter(obj);
  try
    proc;
  finally
    System.MonitorExit(obj);
  end;
end;

procedure Lock(const intf: IInterface; const proc: TProc);
var
  obj: TObject;
begin
  //TArgument.CheckNotNull(intf, 'intf');
  obj := TObject(intf);
  Lock(obj, proc);
end; }

{procedure UpdateStrings(strings: TStrings; proc: TProc);
begin
  TArgument.CheckNotNull(strings, 'strings');
  TArgument.CheckNotNull(Assigned(proc), 'proc');

  strings.BeginUpdate;
  try
    strings.Clear;
    proc;
  finally
    strings.EndUpdate;
  end;
end; }

function IsCtrlPressed: Boolean;
begin
  Result := GetKeyState(VK_CONTROL) < 0;
end;

function IsShiftPressed: Boolean;
begin
  Result := GetKeyState(VK_SHIFT) < 0;
end;

/// <remarks>
/// The virtual code of ALT is VK_MENU For history reasons.
/// </remarks>
function IsAltPressed: Boolean;
begin
  Result := GetKeyState(VK_MENU) < 0;
end;

procedure CheckFileExists(const fileName: string);
begin
  if not FileExists(fileName) then
  begin
    //raise EFileNotFoundException.CreateResFmt(@SFileNotFoundException, [fileName]);
    raise EIOException.CreateResFmt(@SFileNotFoundException, [fileName]);

  end;
end;

procedure CheckDirectoryExists(const directory: string);
begin
  if not DirectoryExists(directory) then
  begin
    ///raise EDirectoryNotFoundException.CreateResFmt(@SDirectoryNotFoundException, [directory]);
    raise EIOException.CreateResFmt(@SDirectoryNotFoundException, [directory]);

  end;
end;

{$ENDREGION}

{function SplitString(const buffer: string; const separators: TSysCharSet;
  removeEmptyEntries: Boolean = False): TStringDynArray; overload;
function SplitString(const buffer: TCharArray; const separators: TSysCharSet;
  removeEmptyEntries: Boolean = False): TStringDynArray; overload;
function SplitString(const buffer: PChar; len: Integer; const separators: TSysCharSet;
  removeEmptyEntries: Boolean = False): TStringDynArray; overload;
}


function CharInSet(const Ch: Char; const SetOfChar: TSysCharSet): Boolean;
begin
  {$IFDEF Delphi}
  Result := Ch in SetOfChar;
  {$ENDIF Delphi}
  {$IFDEF BCB}
  Result := Pos(Ch, SetOfChar) > 0;
  {$ENDIF BCB}
end;



 function SplitString(const buffer: string; const separators: TSysCharSet;
  removeEmptyEntries: Boolean): TStringDynArray;
begin
  Result := SplitString(PChar(buffer), Length(buffer), separators, removeEmptyEntries);
end;

function SplitString(const buffer: TCharArray; const separators: TSysCharSet;
  removeEmptyEntries: Boolean): TStringDynArray;
begin
  Result := SplitString(PChar(buffer), Length(buffer), separators, removeEmptyEntries)
end;

function SplitString(const buffer: PChar; len: Integer; const separators: TSysCharSet;
  removeEmptyEntries: Boolean): TStringDynArray;
var
  head: PChar;
  tail: PChar;
  p: PChar;

  procedure AppendEntry(buffer: PChar; len: Integer; var strings: TStringDynArray);
  var
    entry: string;
  begin
    SetString(entry, buffer, len);
    if not removeEmptyEntries or (entry <> '') then
    begin
      SetLength(strings, Length(strings) + 1);
      strings[Length(strings) - 1] := entry;
    end;
  end;
begin
  //TArgument.CheckRange(len >= 0, 'len');

  if (buffer = nil) or (len = 0) then Exit;
  head := buffer;
  tail := head + len - 1;
  p := head;
  while p <= tail do
  begin
    if CharInSet(p^, separators) then
    begin
      AppendEntry(head, p - head, Result);
      head := StrNextChar(p);
    end;
    if p = tail then
    begin
      AppendEntry(head, p - head + 1, Result);
    end;
    p := StrNextChar(p);
  end;
end;

function SplitString(const buffer: PChar): TStringDynArray;
var
  p: PChar;
  entry: string;
begin
  if (buffer = nil) or (buffer^ = #0) then Exit;
  p := buffer;
  while p^ <> #0 do
  begin
    entry := p;
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result)-1] := entry;
    Inc(p, Length(entry) + 1);  // Jump to the next entry
  end;
end;


{$REGION 'TVersion'}

constructor TVersion.Create(const versionString: string);
var
  components: TStringDynArray;
  major: Integer;
  minor: Integer;
  build: Integer;
  reversion: Integer;
begin
  components := SplitString(versionString, ['.']);
  if not (Length(components) in [2..4]) then
  begin
    raise EIOException.Create('version');
  end;
  try
    major := StrToInt(components[0]);
    minor := StrToInt(components[1]);
    if Length(components) >= 3 then
    begin
      build := StrToInt(components[2]);
    end
    else
    begin
      build := -1;
    end;
    if Length(components) = 4 then
    begin
      reversion := StrToInt(components[3]);
    end
    else
    begin
      reversion := -1;
    end;
  except on e: Exception do
    //raise EFormatException.Create(e.Message);
    raise EIOException.Create(e.Message);

  end;
  InternalCreate(Length(components), major, minor, build, reversion);
end;

constructor TVersion.Create(major, minor: Integer);
begin
  InternalCreate(2, major, minor, -1, -1);
end;

constructor TVersion.Create(major, minor, build: Integer);
begin
  InternalCreate(3, major, minor, build, -1);
end;

constructor TVersion.Create(major, minor, build, reversion: Integer);
begin
  InternalCreate(4, major, minor, build, reversion);
end;

constructor TVersion.InternalCreate(defined, major, minor, build, reversion: Integer);
begin
  Assert(defined in [2, 3, 4], '"defined" should be in [2, 3, 4].');
  //TArgument.CheckRange(IsDefined(major), 'major');
  //TArgument.CheckRange(IsDefined(minor), 'minor');
  fMajor := major;
  fMinor := minor;
  case defined of
    2:
    begin
      fBuild := fCUndefined;
      fReversion := fCUndefined;
    end;
    3:
    begin
      //TArgument.CheckRange(IsDefined(build), 'build');
      fBuild := build;
      fReversion := fCUndefined;
    end;
    4:
    begin
      //TArgument.CheckRange(IsDefined(build), 'build');
      //TArgument.CheckRange(IsDefined(reversion), 'reversion');
      fBuild := build;
      fReversion := reversion;
    end;
  end;
end;

function TVersion.IsDefined(const component: Integer): Boolean;
begin
  Result := component <> fCUndefined;
end;

function TVersion.Equals(const version: TVersion): Boolean;
begin
  Result := CompareTo(version) = 0;
end;

function TVersion.CompareComponent(a, b: Integer): Integer;
begin
  if IsDefined(a) and IsDefined(b) then
  begin
    Result := a - b;
  end
  else if IsDefined(a) and not IsDefined(b) then
  begin
    Result := 1;
  end
  else if not IsDefined(a) and IsDefined(b) then
  begin
    Result := -1;
  end
  else
  begin
    Result := 0;
  end;
end;

function TVersion.CompareTo(const version: TVersion): Integer;
begin
  Result := Major - version.Major;
  if Result = 0 then
  begin
    Result := Minor - version.Minor;
    if Result = 0 then
    begin
      Result := CompareComponent(Build, version.Build);
      if Result = 0 then
      begin
        Result := CompareComponent(Reversion, version.Reversion);
      end;
    end;
  end;
end;

function TVersion.ToString: string;
begin
  if not IsDefined(fBuild) then
    Result := ToString(2)
  else if not IsDefined(fReversion) then
    Result := ToString(3)
  else
    Result := ToString(4);
end;

function TVersion.ToString(fieldCount: Integer): string;
begin
  //TArgument.CheckRange(fieldCount in [0..4], 'fieldCount');
  case fieldCount of
    0: Result := '';
    1: Result := Format('%d', [major]);
    2: Result := Format('%d.%d', [major, minor]);
    3:
    begin
      //TArgument.CheckTrue(IsDefined(build), SIllegalFieldCount);
      Result := Format('%d.%d.%d', [major, minor, build]);
    end;
    4:
    begin
      //TArgument.CheckTrue(IsDefined(build) and IsDefined(reversion), SIllegalFieldCount);
      Result := Format('%d.%d.%d.%d', [major, minor, build, reversion]);
    end;
  end;
end;

function TVersion.GetMajorReversion: Integer;
begin
  Result := Reversion shr 16;
end;

function TVersion.GetMinorReversion: Integer;
begin
  Result := Reversion and $0000FFFF;
end;




{$REGION 'TOperatingSystem'}


const
  // ProductType

  VER_NT_WORKSTATION                 = $0000001;
  VER_NT_DOMAIN_CONTROLLER           = $0000002;
  VER_NT_SERVER                      = $0000003;


constructor TOperatingSystem.Create;
var
  versionInfo: TOSVersionInfoEx; //Ex;
begin
  inherited Create;
  ZeroMemory(@versionInfo, SizeOf(versionInfo));
  versionInfo.dwOSVersionInfoSize := SizeOf(versionInfo);
  Win32Check(GetVersionEx(versionInfo));
  case versionInfo.dwPlatformId of
    VER_PLATFORM_WIN32s:        fPlatformType := ptWin3x;
    VER_PLATFORM_WIN32_WINDOWS: fPlatformType := ptWin9x;
    VER_PLATFORM_WIN32_NT:      fPlatformType := ptWinNT;
    else fPlatformType := ptUnknown;
  end;
  fProductType := ptInvalid;
  case versionInfo.wProductType of
    VER_NT_WORKSTATION:       fProductType := ptWorkstation;
    VER_NT_DOMAIN_CONTROLLER: fProductType := ptDomainController;
    VER_NT_SERVER:            fProductType := ptServer;
  end;
  fVersion := TVersion.Create(
    versionInfo.dwMajorVersion,
    versionInfo.dwMinorVersion,
    versionInfo.dwBuildNumber
  );
  fVersionType := GetOSVersionType(
    fPlatformType,
    fProductType,
    versionInfo.dwMajorVersion,
    versionInfo.dwMinorVersion
  );
  fServicePack := versionInfo.szCSDVersion;
end;

function TOperatingSystem.GetOSVersionType(platformType: TOSPlatformType;
  productType: TOSProductType; majorVersion, minorVersion: Integer): TOSVersionType;
begin
  Result := vtUnknown;
  case platformType of
    ptWin9x:
    begin
      if majorVersion = 4 then
      case minorVersion of
        0:  Result := vtWin95;
        10: Result := vtWin98;
        90: Result := vtWinMe;
      end;
    end;
    ptWinNT:
    begin
      if (majorVersion = 3) and (minorVersion = 51) then
      begin
        Result := vtWinNT351;
      end
      else if (majorVersion = 4) and (minorVersion = 0) then
      begin
        Result := vtWinNT4;
      end
      else if majorVersion = 5 then
      case minorVersion of
        0: Result := vtWinServer2000;
        1: Result := vtWinXP;
        2: Result := vtWinServer2003;
      end
      else if majorVersion = 6 then
      case minorVersion of
        0:
        begin
          if productType = ptWorkstation then
            Result := vtWinVista
          else
            Result := vtWinServer2008;
        end;
        1:
        begin
          if productType = ptWorkstation then
            Result := vtWin7
          else
            Result := vtWinServer2008;   { TODO: WinServer2008 R2 }
        end;
      end;
    end;
  end;
end;

function TOperatingSystem.ToString: string;
begin
  Result := OSVersionTypeStrings[fVersionType];
  if fVersionType <> vtUnknown then
  begin
    Result := Result + ' Version ' + fVersion.ToString;
    if ServicePack <> '' then
      Result := Result + ' ' + ServicePack;
  end;
end;

function TOperatingSystem.GetIsWin3x: Boolean;
begin
  Result := Self.PlatformType = ptWin3x;
end;

function TOperatingSystem.GetIsWin9x: Boolean;
begin
  Result := Self.PlatformType = ptWin9x;
end;

function TOperatingSystem.GetIsWinNT: Boolean;
begin
  Result := Self.PlatformType = ptWinNT;
end;

function TOperatingSystem.GetVersionString: string;
begin
  Result := ToString;
end;

{$ENDREGION}


{$REGION 'TEnvironment'}

constructor TEnvironmentClass.Create;
begin
  fApplicationPath := ExtractFilePath(ParamStr(0));
  fApplicationVersionInfo := TFileVersionInfo.GetVersionInfo(ParamStr(0));
  fApplicationVersion := fApplicationVersionInfo.FileVersionNumber;
  fApplicationVersionString := fApplicationVersionInfo.FileVersion;
  fOperatingSystem := TOperatingSystem.Create;
end;

 destructor TEnvironmentClass.Destroy;
begin
  fOperatingSystem.Free;
end;

 class function TEnvironmentClass.GetCommandLineArgs: TStringDynArray;
var
  pArgs: PPWideChar;
  count: Integer;
  i: Integer;
begin
  pArgs := ShellAPI.CommandLineToArgvW(PWideChar(Windows.GetCommandLineW), count);
  if pArgs <> nil then
  try
    SetLength(Result, count);
    for i := 0 to count - 1 do
    begin
      Result[i] := string(pArgs^);
      Inc(pArgs);
    end;
  finally
    Windows.LocalFree(HLocal(pArgs));
  end;
end;

 {procedure TEnvironmentClass.GetCommandLineArgs(list: TStrings);
var
  args: TStringDynArray;
begin
  args := GetCommandLineArgs;
  UpdateStrings(list,
    procedure
    var
      i: Integer;
    begin
      for i := 0 to High(args) do
      begin
        list.Add(args[i]);
      end;
    end
  );
end; }

 class function TEnvironmentClass.GetLogicalDrives: TStringDynArray;
var
  len: Cardinal;
  buffer: string;
begin
  len := Windows.GetLogicalDriveStrings(0, nil);
  SetLength(buffer, len);
  Windows.GetLogicalDriveStrings(len * SizeOf(Char), PChar(buffer));
  Result := SplitString(PChar(buffer));
end;

 {procedure TEnvironmentClass.GetLogicalDrives(list: TStrings);
var
  drives: TStringDynArray;
begin
  drives := GetLogicalDrives;
  //UpdateStrings(list,
    procedure
    var
      drive: string;
    begin
      for drive in drives do
      begin
        list.Add(drive);
      end;
    end
  );
end; }

function TryGetAccessToken(out hToken: THandle): Boolean;
begin
  Result := Windows.OpenThreadToken(GetCurrentThread, TOKEN_QUERY, TRUE, hToken);
  if not Result and (Windows.GetLastError = ERROR_NO_TOKEN) then
  begin
    Result := Windows.OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hToken);
  end;
end;

//function SHGetSpecialFolderLocation;    external shell32 name 'SHGetSpecialFolderLocation';

class function TEnvironmentClass.GetFolderPath(const folder: TSpecialFolder): string;
var
  pidl : PItemIDList;
  buffer: array[0..MAX_PATH-1] of Char;
//  returnCode: HRESULT;
  hToken : THandle;
begin
  if TryGetAccessToken(hToken) then
  try
    ShlObj.SHGetSpecialFolderLocation(INVALID_HANDLE_VALUE,
      SpecialFolderCSIDLs[folder], pidl);
    ShlObj.SHGetPathFromIDList(pidl, @buffer[0]);
    Result := buffer;
  finally
    CloseHandle(hToken);
  end;
end;

 class procedure TEnvironmentClass.OpenEnvironmentVariableKey(registry: TRegistry;
  target: TEnvironmentVariableTarget; keyAccess: Cardinal);
var
  key: string;
begin
  Assert(registry <> nil, 'registry should not be nil.');
  Assert(target in [evtUser, evtMachine], Format('Illegal target: %d.', [Integer(target)]));
  if target = evtUser then
  begin
    registry.RootKey := HKEY_CURRENT_USER;
    key := 'Environment';
  end
  else
  begin
    registry.RootKey := HKEY_LOCAL_MACHINE;
    key := 'System\CurrentControlSet\Control\Session Manager\Environment';
  end;
  registry.Access := keyAccess;
  if not registry.OpenKey(key, False) then
  begin
    raise EOSError.CreateResFmt(@SCannotAccessRegistryKey, [key]);
  end;
end;

 class function TEnvironmentClass.GetEnvironmentVariable(
  const variable: string): string;
begin
  Result := TEnvironmentClass.GetEnvironmentVariable(variable, evtProcess);
end;

 class function TEnvironmentClass.GetEnvironmentVariable(const variable: string;
  target: TEnvironmentVariableTarget): string;
var
  registry: TRegistry;

  function GetProcessEnvironmentVariable: string;
  var
    len: DWORD;
  begin
    len := Windows.GetEnvironmentVariable(PChar(variable), nil, 0);
    if len > 0 then
    begin
      SetLength(Result, len - 1);
      Windows.GetEnvironmentVariable(PChar(variable), PChar(Result), len);
    end
    else
    begin
      Result := '';
    end;
  end;
begin
  //TArgument.CheckEnum<TEnvironmentVariableTarget>(target, 'target');
  if target = evtProcess then
  begin
    Result := GetProcessEnvironmentVariable;
    Exit;
  end;
  registry := TRegistry.Create;
  try
    OpenEnvironmentVariableKey(registry, target, KEY_READ);
    if registry.ValueExists(variable) then
    begin
      //Result := registry.GetDataAsString(variable);
      Result := registry.readString(variable);

    end
    else
    begin
      Result := '';
    end;
  finally
    registry.Free;
  end;
end;

 {procedure TEnvironmentClass.GetProcessEnvironmentVariables(list: TStrings);
var
  p: PChar;
  strings: TStringDynArray;
begin
  Assert(list <> nil, 'list should not be nil.');
  p := Windows.GetEnvironmentStrings;
  try
    strings := SplitString(p);
    UpdateStrings(list,
      procedure
      var
        s: string;
      begin
        for s in strings do
        begin
          if (Length(s) > 0) and (s[1] <> '=') then // Skip entries start with '='
          begin
            list.Add(s);
          end;
        end;
      end
    );
  finally
    Win32Check(Windows.FreeEnvironmentStrings(p));
  end;
end;  }

 class procedure TEnvironmentClass.GetEnvironmentVariables(list: TStrings);
begin
  TEnvironmentClass.GetEnvironmentVariables(list, evtProcess);
end;

 class procedure TEnvironmentClass.GetEnvironmentVariables(list: TStrings;
  target: TEnvironmentVariableTarget);
var
  registry: TRegistry;
  value: string;
  i: Integer;
begin
  //TArgument.CheckNotNull(list, 'list');
  //TArgument.CheckEnum<TEnvironmentVariableTarget>(target, 'target');
  if target = evtProcess then
  begin
    //GetProcessEnvironmentVariables(list);
    Exit;
  end;
  registry := TRegistry.Create;
  try
    OpenEnvironmentVariableKey(registry, target, KEY_READ);
    registry.GetValueNames(list);
    for i := 0 to list.Count - 1 do
    begin
      //value := registry.GetDataAsString(list[i]);
      value := registry.readstring(list[i]);

      list[i] := list[i] + list.NameValueSeparator + value;
    end;
  finally
    registry.Free;
  end;
end;

 class procedure TEnvironmentClass.SetEnvironmentVariable(const variable, value: string);
begin
  TEnvironmentClass.SetEnvironmentVariable(variable, value, evtProcess);
end;

 class procedure TEnvironmentClass.SetEnvironmentVariable(const variable,
  value: string; target: TEnvironmentVariableTarget);
var
  registry: TRegistry;
begin
  //TArgument.CheckEnum<TEnvironmentVariableTarget>(target, 'target');
  if target = evtProcess then
  begin
    Win32Check(Windows.SetEnvironmentVariable(PChar(variable), PChar(value)));
    Exit;
  end;
  registry := TRegistry.Create;
  try
    OpenEnvironmentVariableKey(registry, target, KEY_WRITE);
    if Pos('%', value) > 0 then
    begin
      registry.WriteExpandString(variable, value);
    end
    else
    begin
      registry.WriteString(variable, value);
    end;
    SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, Integer(PChar('Environment')));
  finally
    registry.Free;
  end;
end;

 class function TEnvironmentClass.ExpandEnvironmentVariables(
  const variable: string): string;
var
  len: Cardinal;
begin
  len := MAX_PATH;
  SetLength(Result, len);
  len := Windows.ExpandEnvironmentStrings(PChar(variable), PChar(Result), len);
  Win32Check(len > 0);
  SetLength(Result, len - 1);
end;

 class function TEnvironmentClass.GetCommandLine: string;
begin
  Result := Windows.GetCommandLine;
end;

 class function TEnvironmentClass.GetCurrentDirectory: string;
var
  size: DWORD;
begin
  size := Windows.GetCurrentDirectory(0, nil);
  SetLength(Result, size - 1);
  Windows.GetCurrentDirectory(size, PChar(Result));
end;

 class function TEnvironmentClass.GetCurrentVersionKey: string;
const
  HKLM_CURRENT_VERSION_NT      = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion';
  HKLM_CURRENT_VERSION_WINDOWS = 'SOFTWARE\Microsoft\Windows\CurrentVersion';
begin
  //if fOperatingSystem.IsWinNT then
    //Result := HKLM_CURRENT_VERSION_NT
  ///else
    Result := HKLM_CURRENT_VERSION_WINDOWS;
end;

 class function TEnvironmentClass.GetMachineName: string;
var
  size: Cardinal;
begin
  size := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, size);
  if GetComputerName(PChar(Result), size) then
  begin
    SetLength(Result, size);
  end;
end;

 class function TEnvironmentClass.GetNewLine: string;
begin
  Result := System.sLineBreak;
end;

 class function TEnvironmentClass.GetProcessorArchitecture: TProcessorArchitecture;
var
  systemInfo: TSystemInfo;
const
  PROCESSOR_ARCHITECTURE_INTEL          = 0;
  PROCESSOR_ARCHITECTURE_AMD64          = 9;
  PROCESSOR_ARCHITECTURE_IA32_ON_WIN64  = 10;
  PROCESSOR_ARCHITECTURE_IA64           = 6;
begin
  ZeroMemory(@systemInfo, Sizeof(systemInfo));
  Windows.GetSystemInfo(systemInfo);
  case systemInfo.wProcessorArchitecture of
    PROCESSOR_ARCHITECTURE_INTEL:
      Result := paX86;
    PROCESSOR_ARCHITECTURE_IA64:
      Result := paIA64;
    PROCESSOR_ARCHITECTURE_AMD64:
      Result := paAmd64;
    else
      Result := paUnknown;
  end;
end;

 class function TEnvironmentClass.GetProcessorCount: Integer;
var
  systemInfo: TSystemInfo;
begin
  ZeroMemory(@systemInfo, Sizeof(systemInfo));
  Windows.GetSystemInfo(systemInfo);
  Result := systemInfo.dwNumberOfProcessors;
end;

 class function TEnvironmentClass.GetRegisteredOrganization: string;
begin
  {$IFDEF HAS_UNITSCOPE}
  Result := System.Win.ComObj.GetRegStringValue(
  {$ELSE}
  Result :=ComObj.GetRegStringValue(
  {$ENDIF}
    GetCurrentVersionKey,
    'RegisteredOrganization',  // DO NOT LOCALIZE
    HKEY_LOCAL_MACHINE
  );
end;

 class function TEnvironmentClass.GetRegisteredOwner: string;
begin
  {$IFDEF HAS_UNITSCOPE}
  Result := System.Win.ComObj.GetRegStringValue(
  {$ELSE}
  Result :=ComObj.GetRegStringValue(
  {$ENDIF}
    GetCurrentVersionKey,
    'RegisteredOwner',  // DO NOT LOCALIZE
    HKEY_LOCAL_MACHINE
  );
end;

 class function TEnvironmentClass.GetSystemDirectory: string;
begin
  Result := TEnvironmentClass.GetFolderPath(sfSystem);
end;

 class function TEnvironmentClass.GetUserDomainName: string;
var
  hasToken: Boolean;
  hToken: THandle;
  ptiUser: PSIDAndAttributes;
  cbti: DWORD;
  snu: SID_NAME_USE;
  userSize, domainSize: Cardinal;
  userName: string;
begin
  ptiUser := nil;
  userSize := 0;
  domainSize := 0;
  hasToken := Windows.OpenThreadToken(GetCurrentThread, TOKEN_QUERY, TRUE, hToken);
  if not hasToken and (Windows.GetLastError = ERROR_NO_TOKEN) then
  begin
    hasToken := Windows.OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hToken);
  end;
  if hasToken then
  try
    Windows.GetTokenInformation(hToken, TokenUser, nil, 0, cbti);
    ptiUser := AllocMem(cbti);
    if Windows.GetTokenInformation(hToken, TokenUser, ptiUser, cbti, cbti) then
    begin
      if not Windows.LookupAccountSid(nil, ptiUser.Sid, nil, userSize, nil, domainSize, snu) and
        (Windows.GetLastError = ERROR_INSUFFICIENT_BUFFER) then
      begin
        SetLength(userName, userSize - 1);
        SetLength(Result, domainSize - 1);
        Win32Check(Windows.LookupAccountSid(nil, ptiUser.Sid, PChar(userName), userSize,
          PChar(Result), domainSize, snu));
      end;
    end;
  finally
    Windows.CloseHandle(hToken);
    FreeMem(ptiUser);
  end;
end;

 class function TEnvironmentClass.GetUserInteractive: Boolean;
begin
  { TODO: UserInteractive }
  Result := True;
end;

 class function TEnvironmentClass.GetUserName: string;
var
  size: Cardinal;
begin
  size := 255;
  SetLength(Result, size);
  Win32Check(Windows.GetUserName(PChar(Result), size));
  SetLength(Result, size - 1);
end;

/// http://www.gumpi.com/Blog/2007/10/02/EKON11PromisedEntry3.aspx
/// <author>Daniel Wischnewski</author>
 class function TEnvironmentClass.GetIsAdmin: Boolean;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
  SE_GROUP_ENABLED = $00000004;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
begin
  Result   := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, hAccessToken);
  if not bSuccess then
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken);
  if bSuccess then
  begin
    GetTokenInformation(hAccessToken, TokenGroups, nil, 0, dwInfoBufferSize);
    ptgGroups := GetMemory(dwInfoBufferSize);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, dwInfoBufferSize, dwInfoBufferSize);
    CloseHandle(hAccessToken);
    if bSuccess then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, psidAdministrators);
      for x := 0 to ptgGroups.GroupCount - 1 do
      begin
        if (SE_GROUP_ENABLED = (ptgGroups.Groups[x].Attributes and SE_GROUP_ENABLED)) and EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
        begin
          Result := True;
          Break;
        end;
      end;
      FreeSid(psidAdministrators);
    end;
    FreeMem(ptgGroups);
  end;
end;

 class function TEnvironmentClass.GetTickCount: Cardinal;
begin
  Result := Windows.GetTickCount;
end;

 class procedure TEnvironmentClass.SetCurrentDirectory(const value: string);
begin
  Win32Check(Windows.SetCurrentDirectory(PChar(value)));
end;

{$ENDREGION}





end.
