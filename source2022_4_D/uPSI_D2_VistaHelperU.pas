unit uPSI_D2_VistaHelperU;
{
   a mixed function block
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_D2_VistaHelperU = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_D2_VistaHelperU(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_D2_VistaHelperU_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Forms
  ,Graphics
  ,Windows
  //,D2_VistaHelperU
  ,XPVistaHelperU
  ;

//    function GetVersionEx3(out verinfo: TOSVersionInfoEx): boolean;
  //var verinfo: TOSVersionInfo
  //   External  'GetVersionExA@kernel32.dll stdcall';

  function GetVersionEx3(out verinfo: TOSVersionInfoEx): boolean; stdcall;
                                    //cb: DWORD): BOOL; //stdcall;
     external 'kernel32.dll' name 'GetVersionExA';



procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_D2_VistaHelperU]);
end;


function getVersionInfoEx3: TOSVersionInfoEx;
var
  aInfo: TOSVersionInfoEx;
begin
  //Result:= 0;
  aInfo.dwOSVersionInfoSize:= SizeOf(aInfo);
  if GetVersionEx3(aInfo) then
    Result:= aInfo;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_D2_VistaHelperU(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('PRODUCT_UNDEFINED','LongWord').SetUInt( $00000000);
 CL.AddConstantN('PRODUCT_ULTIMATE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('PRODUCT_HOME_BASIC','LongWord').SetUInt( $00000002);
 CL.AddConstantN('PRODUCT_HOME_PREMIUM','LongWord').SetUInt( $00000003);
 CL.AddConstantN('PRODUCT_ENTERPRISE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('PRODUCT_HOME_BASIC_N','LongWord').SetUInt( $00000005);
 CL.AddConstantN('PRODUCT_BUSINESS','LongWord').SetUInt( $00000006);
 CL.AddConstantN('PRODUCT_STANDARD_SERVER','LongWord').SetUInt( $00000007);
 CL.AddConstantN('PRODUCT_DATACENTER_SERVER','LongWord').SetUInt( $00000008);
 CL.AddConstantN('PRODUCT_SMALLBUSINESS_SERVER','LongWord').SetUInt( $00000009);
 CL.AddConstantN('PRODUCT_ENTERPRISE_SERVER','LongWord').SetUInt( $0000000A);
 CL.AddConstantN('PRODUCT_STARTER','LongWord').SetUInt( $0000000B);
 CL.AddConstantN('PRODUCT_DATACENTER_SERVER_CORE','LongWord').SetUInt( $0000000C);
 CL.AddConstantN('PRODUCT_STANDARD_SERVER_CORE','LongWord').SetUInt( $0000000D);
 CL.AddConstantN('PRODUCT_ENTERPRISE_SERVER_CORE','LongWord').SetUInt( $0000000E);
 CL.AddConstantN('PRODUCT_ENTERPRISE_SERVER_IA64','LongWord').SetUInt( $0000000F);
 CL.AddConstantN('PRODUCT_BUSINESS_N','LongWord').SetUInt( $00000010);
 CL.AddConstantN('PRODUCT_WEB_SERVER','LongWord').SetUInt( $00000011);
 CL.AddConstantN('PRODUCT_CLUSTER_SERVER','LongWord').SetUInt( $00000012);
 CL.AddConstantN('PRODUCT_HOME_SERVER','LongWord').SetUInt( $00000013);
 CL.AddConstantN('PRODUCT_STORAGE_EXPRESS_SERVER','LongWord').SetUInt( $00000014);
 CL.AddConstantN('PRODUCT_STORAGE_STANDARD_SERVER','LongWord').SetUInt( $00000015);
 CL.AddConstantN('PRODUCT_STORAGE_WORKGROUP_SERVER','LongWord').SetUInt( $00000016);
 CL.AddConstantN('PRODUCT_STORAGE_ENTERPRISE_SERVER','LongWord').SetUInt( $00000017);
 CL.AddConstantN('PRODUCT_SERVER_FOR_SMALLBUSINESS','LongWord').SetUInt( $00000018);
 CL.AddConstantN('PRODUCT_SMALLBUSINESS_SERVER_PREMIUM','LongWord').SetUInt( $00000019);
 CL.AddConstantN('PRODUCT_UNLICENSED','LongWord').SetUInt( $ABCDABCD);
 CL.AddConstantN('PM_NOREMOVE','LongInt').SetInt( 0);
 CL.AddConstantN('PM_REMOVE','LongInt').SetInt( 1);
 CL.AddConstantN('PM_NOYIELD','LongInt').SetInt( 2);
 CL.AddTypeS('tagCOMPAREITEMSTRUCT', 'record CtlType : UINT; CtlID : UINT; hwn'
   +'dItem : HWND; itemID1 : UINT; itemData1 : DWORD; itemID2 : UINT; itemData2'
   +' : DWORD; dwLocaleId : DWORD; end');
  CL.AddTypeS('TCompareItemStruct', 'tagCOMPAREITEMSTRUCT');
  CL.AddTypeS('COMPAREITEMSTRUCT', 'tagCOMPAREITEMSTRUCT');
   CL.AddTypeS('tagSTYLESTRUCT', 'record styleOld : DWORD; styleNew : DWORD; end');
  CL.AddTypeS('TStyleStruct', 'tagSTYLESTRUCT');
  CL.AddTypeS('STYLESTRUCT', 'tagSTYLESTRUCT');
  CL.AddConstantN('MOD_ALT','LongInt').SetInt( 1);
 CL.AddConstantN('MOD_CONTROL','LongInt').SetInt( 2);
 CL.AddConstantN('MOD_SHIFT','LongInt').SetInt( 4);
 CL.AddConstantN('MOD_WIN','LongInt').SetInt( 8);
 CL.AddConstantN('IDHOT_SNAPWINDOW','LongInt').SetInt( - 1);
 CL.AddConstantN('IDHOT_SNAPDESKTOP','LongInt').SetInt( - 2);
  CL.AddConstantN('WAIT_FAILED','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddConstantN('WAIT_TIMEOUT','longword').SetUint( $00000102);
 CL.AddConstantN('WAIT_IO_COMPLETION','longword').SetUint($000000C0);
 CL.AddConstantN('STILL_ACTIVE','longword').Setuint($00000103);
 CL.AddConstantN('EXCEPTION_ACCESS_VIOLATION','longword').Setuint($C0000005);
  CL.AddConstantN('BDR_RAISEDOUTER','LongInt').SetInt( 1);
 CL.AddConstantN('BDR_SUNKENOUTER','LongInt').SetInt( 2);
 CL.AddConstantN('BDR_RAISEDINNER','LongInt').SetInt( 4);
 CL.AddConstantN('BDR_SUNKENINNER','LongInt').SetInt( 8);
 CL.AddConstantN('BDR_OUTER','LongInt').SetInt( 3);
 CL.AddConstantN('BDR_INNER','LongInt').SetInt( 12);
 CL.AddConstantN('BDR_RAISED','LongInt').SetInt( 5);
 CL.AddConstantN('BDR_SUNKEN','LongInt').SetInt( 10);
 CL.AddConstantN('BF_LEFT','LongInt').SetInt( 1);
 CL.AddConstantN('BF_TOP','LongInt').SetInt( 2);
 CL.AddConstantN('BF_RIGHT','LongInt').SetInt( 4);
 CL.AddConstantN('BF_BOTTOM','LongInt').SetInt( 8);
 CL.AddConstantN('BF_DIAGONAL','LongWord').SetUInt( $10);
 CL.AddConstantN('BF_MIDDLE','LongWord').SetUInt( $800);
 CL.AddConstantN('BF_SOFT','LongWord').SetUInt( $1000);
 CL.AddConstantN('BF_ADJUST','LongWord').SetUInt( $2000);
 CL.AddConstantN('BF_FLAT','LongWord').SetUInt( $4000);
 CL.AddConstantN('BF_MONO','LongWord').SetUInt( $8000);

 CL.AddConstantN('IDOK','LongInt').SetInt( 1);
 CL.AddConstantN('IDCANCEL','LongInt').SetInt( 2);
 CL.AddConstantN('IDABORT','LongInt').SetInt( 3);
 CL.AddConstantN('IDRETRY','LongInt').SetInt( 4);
 CL.AddConstantN('IDIGNORE','LongInt').SetInt( 5);
 CL.AddConstantN('IDYES','LongInt').SetInt( 6);
 CL.AddConstantN('IDNO','LongInt').SetInt( 7);
 CL.AddConstantN('IDCLOSE','LongInt').SetInt( 8);
 CL.AddConstantN('IDHELP','LongInt').SetInt( 9);
 CL.AddConstantN('IDTRYAGAIN','LongInt').SetInt( 10);
 CL.AddConstantN('IDCONTINUE','LongInt').SetInt(11);


 (* {$EXTERNALSYM IDHELP}
  IDHELP = 9;        ID_HELP = IDHELP;
  {$EXTERNALSYM IDTRYAGAIN}
  IDTRYAGAIN = 10;
  {$EXTERNALSYM IDCONTINUE}
  IDCONTINUE = 11; *)

  CL.AddTypeS('tagACCEL', 'record fVirt : Word; key : Word; cmd : Word; end');
  CL.AddTypeS('TAccel', 'tagACCEL');
  CL.AddTypeS('ACCEL', 'tagACCEL');

  CL.AddTypeS('_FINDEX_INFO_LEVELS', '( FindExInfoStandard, FindExInfoMaxInfoLevel )');
  CL.AddTypeS('TFindexInfoLevels', '_FINDEX_INFO_LEVELS');
  CL.AddTypeS('FINDEX_INFO_LEVELS', '_FINDEX_INFO_LEVELS');
  CL.AddTypeS('_FINDEX_SEARCH_OPS', '( FindExSearchNameMatch, FindExSearchLimit'
   +'ToDirectories, FindExSearchLimitToDevices, FindExSearchMaxSearchOp )');
  CL.AddTypeS('TFindexSearchOps', '_FINDEX_SEARCH_OPS');
  CL.AddTypeS('FINDEX_SEARCH_OPS', '_FINDEX_SEARCH_OPS');
 CL.AddConstantN('FIND_FIRST_EX_CASE_SENSITIVE','LongWord').SetUInt( $00000001);
 CL.AddDelphiFunction('Function FindFirstFileEx( lpFileName : PChar; fInfoLevelId : TFindexInfoLevels; lpFindFileData : ___Pointer; fSearchOp : TFindexSearchOps; lpSearchFilter : ___Pointer; dwAdditionalFlags : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function FindFirstFileExA( lpFileName : PAnsiChar; fInfoLevelId : TFindexInfoLevels; lpFindFileData : Pointer; fSearchOp : TFindexSearchOps; lpSearchFilter : Pointer; dwAdditionalFlags : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function FindFirstFileExW( lpFileName : PWideChar; fInfoLevelId : TFindexInfoLevels; lpFindFileData : Pointer; fSearchOp : TFindexSearchOps; lpSearchFilter : Pointer; dwAdditionalFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function FindFirstFile( lpFileName : PChar; var lpFindFileData : TWIN32FindData) : THandle');
 //CL.AddDelphiFunction('Function FindFirstFileA( lpFileName : PAnsiChar; var lpFindFileData : TWIN32FindDataA) : THandle');
 //CL.AddDelphiFunction('Function FindFirstFileW( lpFileName : PWideChar; var lpFindFileData : TWIN32FindDataW) : THandle');
 CL.AddDelphiFunction('Function FindNextFile( hFindFile : THandle; var lpFindFileData : TWIN32FindData) : BOOL');
// CL.AddDelphiFunction('Function FindNextFileA( hFindFile : THandle; var lpFindFileData : TWIN32FindDataA) : BOOL');
 //CL.AddDelphiFunction('Function FindNextFileW( hFindFile : THandle; var lpFindFileData : TWIN32FindDataW) : BOOL');
 CL.AddDelphiFunction('Function SearchPathW( lpPath, lpFileName, lpExtension : PChar; nBufferLength : DWORD; lpBuffer : PChar; var lpFilePart : PChar) : DWORD');
 CL.AddTypeS('_GET_FILEEX_INFO_LEVELS', '( GetFileExInfoStandard, GetFileExMax,InfoLevel )');
  CL.AddTypeS('TGetFileExInfoLevels', '_GET_FILEEX_INFO_LEVELS');
  CL.AddTypeS('GET_FILEEX_INFO_LEVELS', '_GET_FILEEX_INFO_LEVELS');
 CL.AddDelphiFunction('Function GetFileAttributesEx( lpFileName : PChar; fInfoLevelId : TGetFileExInfoLevels; lpFileInformation : ___Pointer) : BOOL');

 CL.AddTypeS('_OSVERSIONINFOEXA', 'record dwOSVersionInfoSize: DWORD; dwMajorVersion: DWORD; dwMinorVersion: DWORD; dwBuildNumber: DWORD; '+
              'dwPlatformId: DWORD; szCSDVersion: array[0..127] of Char; wServicePackMajor: Word;' +
              'wServicePackMinor: WORD; wSuiteMask: WORD; wProductType: Byte; wReserved: Byte; end');


 { TOSVersionInfoEx2 = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar;
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: Byte;
    wReserved: Byte;
  end; }


  CL.AddTypeS('OSVERSIONINFOEXA', '_OSVERSIONINFOEXA');
  CL.AddTypeS('TOSVersionInfoExA', '_OSVERSIONINFOEXA');
  CL.AddTypeS('TOSVersionInfoEx', '_OSVERSIONINFOEXA');
  CL.AddTypeS('TDrivesProperty', 'array[1..26] of boolean;');

  //TDrivesProperty = array['A'..'Z'] of boolean;
 CL.AddDelphiFunction('Function TBSetSystemTime( DateTime : TDateTime; DOW : word) : boolean');
 CL.AddDelphiFunction('Function IsElevated : Boolean');
 CL.AddDelphiFunction('Procedure CoCreateInstanceAsAdmin( aHWnd : HWND; const aClassID : TGUID; const aIID : TGUID; out aObj: TObject)');
  CL.AddTypeS('TPasswordUsage', '( pu_None, pu_Default, pu_Defined )');
 CL.AddDelphiFunction('Function TrimNetResource( UNC : string) : string');
 CL.AddDelphiFunction('Procedure GetFreeDrives( var FreeDrives : TDrivesProperty)');
 CL.AddDelphiFunction('Procedure GetMappedDrives( var MappedDrives : TDrivesProperty)');
 CL.AddDelphiFunction('Function MapDrive( UNCPath : string; Drive : char; PasswordUsage : TPasswordUsage; Password : string; UserUsage : TPasswordUsage; User : string; Comment : string) : boolean');
 CL.AddDelphiFunction('Function UnmapDrive( Drive : char; Force : boolean) : boolean');
 CL.AddDelphiFunction('Function TBIsWindowsVista : Boolean');
 CL.AddDelphiFunction('Procedure SetVistaFonts( const AForm : TForm)');
 CL.AddDelphiFunction('Procedure SetVistaContentFonts( const AFont : TFont)');
 CL.AddDelphiFunction('Function GetProductType( var sType : String) : Boolean');
  CL.AddDelphiFunction('Function lstrcmp( lpString1, lpString2 : PChar) : Integer');
 CL.AddDelphiFunction('Function lstrcmpi( lpString1, lpString2 : PChar) : Integer');
 CL.AddDelphiFunction('Function lstrcpyn( lpString1, lpString2 : PChar; iMaxLength : Integer) : PChar');
 CL.AddDelphiFunction('Function lstrcpy( lpString1, lpString2 : PChar) : PChar');
 CL.AddDelphiFunction('Function lstrcat( lpString1, lpString2 : PChar) : PChar');
 CL.AddDelphiFunction('Function lstrlen( lpString : PChar) : Integer');
 CL.AddDelphiFunction('Function GetTokenInformation( TokenHandle : THandle; TokenInformationClass : TTokenInformationClass; TokenInformation : ___Pointer; TokenInformationLength : DWORD; var ReturnLength : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetTokenInformation( TokenHandle : THandle; TokenInformationClass : TTokenInformationClass; TokenInformation : ___Pointer; TokenInformationLength : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SendNotifyMessage( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : BOOL');
 CL.AddDelphiFunction('Function CreateMutex( lpMutexAttributes : PSecurityAttributes; bInitialOwner : BOOL; lpName : PChar) : THandle');
 //CL.AddDelphiFunction('Function CreateMutexW( lpMutexAttributes : PSecurityAttributes; bInitialOwner : BOOL; lpName : PWideChar) : THandle');
 CL.AddDelphiFunction('Function OpenMutex( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpName : PChar) : THandle');
 CL.AddDelphiFunction('Function CreateEvent( lpEventAttributes : PSecurityAttributes; bManualReset, bInitialState : BOOL; lpName : PChar) : THandle');
 CL.AddDelphiFunction('Function OpenEvent( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpName : PChar) : THandle');
 CL.AddDelphiFunction('Function CreateSemaphore( lpSemaphoreAttributes : PSecurityAttributes; lInitialCount, lMaximumCount : Longint; lpName : PChar) : THandle');
 CL.AddDelphiFunction('Function OpenSemaphore( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpName : PChar) : THandle');
 //S.RegisterDelphiFunction(@GetFileAttributesEx, 'GetFileAttributesEx', CdStdCall);
 CL.AddDelphiFunction('function getVersionInfoEx3: TOSVersionInfoEx;');
 CL.AddDelphiFunction('Function GetVersionEx3(out verinfo: TOSVersionInfoEx): boolean;');




end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_D2_VistaHelperU_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetSystemTime, 'TBSetSystemTime', cdRegister);
 S.RegisterDelphiFunction(@IsElevated, 'IsElevated', cdRegister);
 S.RegisterDelphiFunction(@CoCreateInstanceAsAdmin, 'CoCreateInstanceAsAdmin', cdRegister);
 S.RegisterDelphiFunction(@TrimNetResource, 'TrimNetResource', cdRegister);
 S.RegisterDelphiFunction(@GetFreeDrives, 'GetFreeDrives', cdRegister);
 S.RegisterDelphiFunction(@GetMappedDrives, 'GetMappedDrives', cdRegister);
 S.RegisterDelphiFunction(@MapDrive, 'MapDrive', cdRegister);
 S.RegisterDelphiFunction(@UnmapDrive, 'UnmapDrive', cdRegister);
 S.RegisterDelphiFunction(@IsWindowsVista, 'TBIsWindowsVista', cdRegister);
 S.RegisterDelphiFunction(@SetVistaFonts, 'SetVistaFonts', cdRegister);
 S.RegisterDelphiFunction(@SetVistaContentFonts, 'SetVistaContentFonts', cdRegister);
 S.RegisterDelphiFunction(@GetProductType, 'GetProductType', cdRegister);
  S.RegisterDelphiFunction(@lstrcmp, 'lstrcmp', CdStdCall);
 S.RegisterDelphiFunction(@lstrcmpi, 'lstrcmpi', CdStdCall);
 S.RegisterDelphiFunction(@lstrcpyn, 'lstrcpyn', CdStdCall);
 S.RegisterDelphiFunction(@lstrcpy, 'lstrcpy', CdStdCall);
 S.RegisterDelphiFunction(@lstrcat, 'lstrcat', CdStdCall);
 S.RegisterDelphiFunction(@lstrlen, 'lstrlen', CdStdCall);
 S.RegisterDelphiFunction(@GetTokenInformation, 'GetTokenInformation', CdStdCall);
 S.RegisterDelphiFunction(@SetTokenInformation, 'SetTokenInformation', CdStdCall);
 S.RegisterDelphiFunction(@SendNotifyMessage, 'SendNotifyMessage', CdStdCall);
  S.RegisterDelphiFunction(@CreateMutex, 'CreateMutex', CdStdCall);
 //S.RegisterDelphiFunction(@CreateMutexA, 'CreateMutexA', CdStdCall);
 //S.RegisterDelphiFunction(@CreateMutexW, 'CreateMutexW', CdStdCall);
 S.RegisterDelphiFunction(@OpenMutex, 'OpenMutex', CdStdCall);
  S.RegisterDelphiFunction(@CreateEvent, 'CreateEvent', CdStdCall);
 S.RegisterDelphiFunction(@OpenEvent, 'OpenEvent', CdStdCall);
 S.RegisterDelphiFunction(@CreateSemaphore, 'CreateSemaphore', CdStdCall);
 S.RegisterDelphiFunction(@OpenSemaphore, 'OpenSemaphore', CdStdCall);
 S.RegisterDelphiFunction(@GetFileAttributesEx, 'GetFileAttributesEx', CdStdCall);
 S.RegisterDelphiFunction(@FindFirstFileEx, 'FindFirstFileEx', CdStdCall);
 S.RegisterDelphiFunction(@FindFirstFile, 'FindFirstFile', CdStdCall);
 S.RegisterDelphiFunction(@FindNextFile, 'FindNextFile', CdStdCall);
 S.RegisterDelphiFunction(@SearchPath, 'SearchPathW', CdStdCall);
 S.RegisterDelphiFunction(@getVersionInfoEx3, 'getVersionInfoEx3', CdStdCall);
 S.RegisterDelphiFunction(@GetVersionEx3, 'GetVersionEx3', CdStdCall);

end;



{ TPSImport_D2_VistaHelperU }
(*----------------------------------------------------------------------------*)
procedure TPSImport_D2_VistaHelperU.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_D2_VistaHelperU(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_D2_VistaHelperU.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_D2_VistaHelperU(ri);
  RIRegister_D2_VistaHelperU_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
