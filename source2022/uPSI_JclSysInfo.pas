unit uPSI_JclSysInfo;
{
  operating systems
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
  TPSImport_JclSysInfo = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclSysInfo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclSysInfo_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  //,ActiveX
  //,ShlObj
  ,JclResources
  ,JclSysInfo
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclSysInfo]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclSysInfo(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TEnvironmentOption', '( eoLocalMachine, eoCurrentUser, eoAdditio'
   +'nal )');
  CL.AddTypeS('TEnvironmentOptions', 'set of TEnvironmentOption');
 CL.AddDelphiFunction('Function DelEnvironmentVar( const Name : string) : Boolean');
 CL.AddDelphiFunction('Function ExpandEnvironmentVar( var Value : string) : Boolean');
 CL.AddDelphiFunction('Function GetEnvironmentVar( const Name : string; var Value : string; Expand : Boolean) : Boolean');
 CL.AddDelphiFunction('Function GetEnvironmentVars( const Vars : TStrings; Expand : Boolean) : Boolean');
 CL.AddDelphiFunction('Function SetEnvironmentVar( const Name, Value : string) : Boolean');
 CL.AddDelphiFunction('Function CreateEnvironmentBlock( const Options : TEnvironmentOptions; const AdditionalVars : TStrings) : PChar');
 CL.AddDelphiFunction('Function GetCommonFilesFolder : string');
 CL.AddDelphiFunction('Function GetCurrentFolder : string');
 CL.AddDelphiFunction('Function GetProgramFilesFolder : string');
 CL.AddDelphiFunction('Function GetWindowsFolder : string');
 CL.AddDelphiFunction('Function GetWindowsSystemFolder : string');
 CL.AddDelphiFunction('Function GetWindowsTempFolder : string');
 CL.AddDelphiFunction('Function GetDesktopFolder : string');
 CL.AddDelphiFunction('Function GetProgramsFolder : string');
 CL.AddDelphiFunction('Function GetPersonalFolder : string');
 CL.AddDelphiFunction('Function GetFavoritesFolder : string');
 CL.AddDelphiFunction('Function GetStartupFolder : string');
 CL.AddDelphiFunction('Function GetRecentFolder : string');
 CL.AddDelphiFunction('Function GetSendToFolder : string');
 CL.AddDelphiFunction('Function GetStartmenuFolder : string');
 CL.AddDelphiFunction('Function GetDesktopDirectoryFolder : string');
 CL.AddDelphiFunction('Function GetNethoodFolder : string');
 CL.AddDelphiFunction('Function GetFontsFolder : string');
 CL.AddDelphiFunction('Function GetCommonStartmenuFolder : string');
 CL.AddDelphiFunction('Function GetCommonProgramsFolder : string');
 CL.AddDelphiFunction('Function GetCommonStartupFolder : string');
 CL.AddDelphiFunction('Function GetCommonDesktopdirectoryFolder : string');
 CL.AddDelphiFunction('Function GetCommonAppdataFolder : string');
 CL.AddDelphiFunction('Function GetAppdataFolder : string');
 CL.AddDelphiFunction('Function GetPrinthoodFolder : string');
 CL.AddDelphiFunction('Function GetCommonFavoritesFolder : string');
 CL.AddDelphiFunction('Function GetTemplatesFolder : string');
 CL.AddDelphiFunction('Function GetInternetCacheFolder : string');
 CL.AddDelphiFunction('Function GetCookiesFolder : string');
 CL.AddDelphiFunction('Function GetHistoryFolder : string');
  CL.AddTypeS('TAPMLineStatus', '( alsOffline, alsOnline, alsUnknown )');
  CL.AddTypeS('TAPMBatteryFlag', '( abfHigh, abfLow, abfCritical, abfCharging, abfNoBattery, abfUnknown )');
 CL.AddDelphiFunction('Function GetAPMLineStatus : TAPMLineStatus');
 CL.AddDelphiFunction('Function GetAPMBatteryFlag : TAPMBatteryFlag');
 CL.AddDelphiFunction('Function GetAPMBatteryLifePercent : Integer');
 CL.AddDelphiFunction('Function GetAPMBatteryLifeTime : DWORD');
 CL.AddDelphiFunction('Function GetAPMBatteryFullLifeTime : DWORD');
 CL.AddDelphiFunction('Function GetVolumeName( const Drive : string) : string');
 CL.AddDelphiFunction('Function GetVolumeSerialNumber( const Drive : string) : string');
 CL.AddDelphiFunction('Function GetVolumeFileSystem( const Drive : string) : string');
 CL.AddDelphiFunction('Function GetIPAddress( const HostName : string) : string');
 CL.AddDelphiFunction('procedure GetIpAddresses(Results: TStrings; const HostName: AnsiString);');

 CL.AddDelphiFunction('Function GetIP( const HostName : string) : string');
 CL.AddDelphiFunction('Function GetLocalComputerName : string');
 CL.AddDelphiFunction('Function GetLocalUserName : string');
 CL.AddDelphiFunction('Function GetUserDomainName( const CurUser : string) : string');
 CL.AddDelphiFunction('Function GetDomainName : string');
 CL.AddDelphiFunction('Function GetRegisteredCompany : string');
 CL.AddDelphiFunction('Function GetRegisteredOwner : string');
 CL.AddDelphiFunction('Function GetBIOSName : string');
 CL.AddDelphiFunction('Function GetBIOSCopyright : string');
 CL.AddDelphiFunction('Function GetBIOSExtendedInfo : string');
 CL.AddDelphiFunction('Function GetBIOSDate : TDateTime');
  CL.AddTypeS('TJclTerminateAppResult', '( taError, taClean, taKill )');
 CL.AddDelphiFunction('Function RunningProcessesList( const List : TStrings; FullPath : Boolean) : Boolean');
 CL.AddDelphiFunction('Function LoadedModulesList( const List : TStrings; ProcessID : DWORD; HandlesOnly : Boolean) : Boolean');
 CL.AddDelphiFunction('Function GetTasksList( const List : TStrings) : Boolean');
 //CL.AddDelphiFunction('Function ModuleFromAddr( const Addr : ___Pointer) : HMODULE');
 CL.AddDelphiFunction('Function IsSystemModule( const Module : HMODULE) : Boolean');
 CL.AddDelphiFunction('Function IsMainAppWindow( Wnd : HWND) : Boolean');
 CL.AddDelphiFunction('Function IsWindowResponding( Wnd : HWND; Timeout : Integer) : Boolean');
 CL.AddDelphiFunction('Function GetWindowIcon( Wnd : HWND; LargeIcon : Boolean) : HICON');
 CL.AddDelphiFunction('Function GetWindowCaption( Wnd : HWND) : string');
 CL.AddDelphiFunction('Function TerminateTask( Wnd : HWND; Timeout : Integer) : TJclTerminateAppResult');
 CL.AddDelphiFunction('Function TerminateApp( ProcessID : DWORD; Timeout : Integer) : TJclTerminateAppResult');
 CL.AddDelphiFunction('Function GetPidFromProcessName( const ProcessName : string) : DWORD');
 CL.AddDelphiFunction('Function GetProcessNameFromWnd( Wnd : HWND) : string');
 CL.AddDelphiFunction('Function GetProcessNameFromPid( PID : DWORD) : string');
 CL.AddDelphiFunction('Function GetMainAppWndFromPid( PID : DWORD) : HWND');
 CL.AddDelphiFunction('Function GetShellProcessName : string');
 CL.AddDelphiFunction('Function GetShellProcessHandle : THandle');
  CL.AddTypeS('TWindowsVersion', '( wvUnknown, wvWin95, wvWin95OSR2, wvWin98, w'
   +'vWin98SE, wvWinME, wvWinNT31, wvWinNT35, wvWinNT351, wvWinNT4, wvWin2000, wvWinXP )');
  CL.AddTypeS('TNtProductType', '( ptUnknown, ptWorkStation, ptServer, ptAdvanc'
   +'edServer, ptPersonal, ptProfessional, ptDatacenterServer )');
 CL.AddDelphiFunction('Function GetWindowsVersion : TWindowsVersion');
 CL.AddDelphiFunction('Function NtProductType : TNtProductType');
 CL.AddDelphiFunction('Function GetWindowsVersionString : string');
 CL.AddDelphiFunction('Function NtProductTypeString : string');
 CL.AddDelphiFunction('Function GetWindowsServicePackVersion : Integer');
 CL.AddDelphiFunction('Function GetWindowsServicePackVersionString : string');
 CL.AddDelphiFunction('Function GetMacAddresses( const Machine : string; const Addresses : TStrings) : Integer');
 CL.AddDelphiFunction('Function ReadTimeStampCounter : Int64');
  CL.AddTypeS('TCacheInfo', 'record D : Byte; I : string; end');
  CL.AddTypeS('TFreqInfo', 'record RawFreq : Cardinal; NormFreq: Cardinal; InCycles: Cardinal; ExTicks : Cardinal; end');

    CL.AddTypeS('TIntelSpecific', 'record L2Cache : Cardinal; CacheDescriptors : array [0..15] of Byte; '
   +'BrandID : Byte; end');
    CL.AddTypeS('TCyrixSpecific', 'record L1CacheInfo: array [0..3] of Byte; TLBInfo : array [0..3] of Byte; '
   +' end');
    CL.AddTypeS('TAMDSpecific', 'record DataTLB: array [0..1] of Byte; InstructionTLB: array [0..1] of Byte; '
   +' L1DataCache: array [0..3] of Byte; L1ICache: array [0..3] of Byte; end');

 {  type
  TIntelSpecific = record
    L2Cache: Cardinal;
    CacheDescriptors: array [0..15] of Byte;
    BrandID : Byte;
  end;
  TCyrixSpecific = record
    L1CacheInfo: array [0..3] of Byte;
    TLBInfo: array [0..3] of Byte;
  end;

  TAMDSpecific = record
    DataTLB: array [0..1] of Byte;
    InstructionTLB: array [0..1] of Byte;
    L1DataCache: array [0..3] of Byte;
    L1ICache: array [0..3] of Byte;
  end;
  }

   CL.AddTypeS('TCpuInfo', 'record HasInstruction : Boolean; MMX : Boolean; IsFD'
   +'IVOK : Boolean; HasCacheInfo : Boolean; HasExtendedInfo : Boolean; CpuType'
   +' : Byte; PType : Byte; Family : Byte; Model : Byte; Stepping : Byte; Featu'
   +'res : Cardinal; FrequencyInfo : TFreqInfo; VendorIDString: array [0..11] of Char; Manufacturer: array [0..9] of Char; CpuName: array [0..47] of Char; IntelSpecific : TIntelSpecific;'
   +' CyrixSpecific : TCyrixSpecific; AMDSpecific : TAMDSpecific; end');

   {TCpuInfo = record
    HasInstruction: Boolean;
    MMX: Boolean;
    IsFDIVOK: Boolean;
    HasCacheInfo: Boolean;
    HasExtendedInfo: Boolean;
    CpuType: Byte;
    PType: Byte;
    Family: Byte;
    Model: Byte;
    Stepping: Byte;
    Features: Cardinal;
    FrequencyInfo: TFreqInfo;
    VendorIDString: array [0..11] of Char;
    Manufacturer: array [0..9] of Char;
    CpuName: array [0..47] of Char;
    IntelSpecific: TIntelSpecific;
    CyrixSpecific: TCyrixSpecific;
    AMDSpecific: TAMDSpecific;
  end;}

  //CL.AddTypeS('TCPUInfo', 'record HasInstruction : Boolean; NormFreq : Cardinal; InC'
   //+'ycles : Cardinal; ExTicks : Cardinal; end');


 CL.AddConstantN('CPU_TYPE_INTEL','LongInt').SetInt( 1);
 CL.AddConstantN('CPU_TYPE_CYRIX','LongInt').SetInt( 2);
 CL.AddConstantN('CPU_TYPE_AMD','LongInt').SetInt( 3);
 CL.AddConstantN('CPU_TYPE_CRUSOE','LongInt').SetInt( 4);
 CL.AddConstantN('FPU_FLAG','LongWord').SetUInt( $00000001);
 CL.AddConstantN('VME_FLAG','LongWord').SetUInt( $00000002);
 CL.AddConstantN('DE_FLAG','LongWord').SetUInt( $00000004);
 CL.AddConstantN('PSE_FLAG','LongWord').SetUInt( $00000008);
 CL.AddConstantN('TSC_FLAG','LongWord').SetUInt( $00000010);
 CL.AddConstantN('MSR_FLAG','LongWord').SetUInt( $00000020);
 CL.AddConstantN('PAE_FLAG','LongWord').SetUInt( $00000040);
 CL.AddConstantN('MCE_FLAG','LongWord').SetUInt( $00000080);
 CL.AddConstantN('CX8_FLAG','LongWord').SetUInt( $00000100);
 CL.AddConstantN('APIC_FLAG','LongWord').SetUInt( $00000200);
 CL.AddConstantN('BIT_10','LongWord').SetUInt( $00000400);
 CL.AddConstantN('SEP_FLAG','LongWord').SetUInt( $00000800);
 CL.AddConstantN('MTRR_FLAG','LongWord').SetUInt( $00001000);
 CL.AddConstantN('PGE_FLAG','LongWord').SetUInt( $00002000);
 CL.AddConstantN('MCA_FLAG','LongWord').SetUInt( $00004000);
 CL.AddConstantN('CMOV_FLAG','LongWord').SetUInt( $00008000);
 CL.AddConstantN('PAT_FLAG','LongWord').SetUInt( $00010000);
 CL.AddConstantN('PSE36_FLAG','LongWord').SetUInt( $00020000);
 CL.AddConstantN('BIT_18','LongWord').SetUInt( $00040000);
 CL.AddConstantN('BIT_19','LongWord').SetUInt( $00080000);
 CL.AddConstantN('BIT_20','LongWord').SetUInt( $00100000);
 CL.AddConstantN('BIT_21','LongWord').SetUInt( $00200000);
 CL.AddConstantN('BIT_22','LongWord').SetUInt( $00400000);
 CL.AddConstantN('MMX_FLAG','LongWord').SetUInt( $00800000);
 CL.AddConstantN('FXSR_FLAG','LongWord').SetUInt( $01000000);
 CL.AddConstantN('BIT_25','LongWord').SetUInt( $02000000);
 CL.AddConstantN('BIT_26','LongWord').SetUInt( $04000000);
 CL.AddConstantN('BIT_27','LongWord').SetUInt( $08000000);
 CL.AddConstantN('BIT_28','LongWord').SetUInt( $10000000);
 CL.AddConstantN('BIT_29','LongWord').SetUInt( $20000000);
 CL.AddConstantN('BIT_30','LongWord').SetUInt( $40000000);
 CL.AddConstantN('BIT_31','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('AMD_FPU_FLAG','LongWord').SetUInt( $00000001);
 CL.AddConstantN('AMD_VME_FLAG','LongWord').SetUInt( $00000002);
 CL.AddConstantN('AMD_DE_FLAG','LongWord').SetUInt( $00000004);
 CL.AddConstantN('AMD_PSE_FLAG','LongWord').SetUInt( $00000008);
 CL.AddConstantN('AMD_TSC_FLAG','LongWord').SetUInt( $00000010);
 CL.AddConstantN('AMD_MSR_FLAG','LongWord').SetUInt( $00000020);
 CL.AddConstantN('AMD_BIT_6','LongWord').SetUInt( $00000040);
 CL.AddConstantN('AMD_MCE_FLAG','LongWord').SetUInt( $00000080);
 CL.AddConstantN('AMD_CX8_FLAG','LongWord').SetUInt( $00000100);
 CL.AddConstantN('AMD_APIC_FLAG','LongWord').SetUInt( $00000200);
 CL.AddConstantN('AMD_BIT_10','LongWord').SetUInt( $00000400);
 CL.AddConstantN('AMD_BIT_11','LongWord').SetUInt( $00000800);
 CL.AddConstantN('AMD_MTRR_FLAG','LongWord').SetUInt( $00001000);
 CL.AddConstantN('AMD_PGE_FLAG','LongWord').SetUInt( $00002000);
 CL.AddConstantN('AMD_BIT_14','LongWord').SetUInt( $00004000);
 CL.AddConstantN('AMD_CMOV_FLAG','LongWord').SetUInt( $00008000);
 CL.AddConstantN('AMD_BIT_16','LongWord').SetUInt( $00010000);
 CL.AddConstantN('AMD_BIT_17','LongWord').SetUInt( $00020000);
 CL.AddConstantN('AMD_BIT_18','LongWord').SetUInt( $00040000);
 CL.AddConstantN('AMD_BIT_19','LongWord').SetUInt( $00080000);
 CL.AddConstantN('AMD_BIT_20','LongWord').SetUInt( $00100000);
 CL.AddConstantN('AMD_BIT_21','LongWord').SetUInt( $00200000);
 CL.AddConstantN('AMD_BIT_22','LongWord').SetUInt( $00400000);
 CL.AddConstantN('AMD_MMX_FLAG','LongWord').SetUInt( $00800000);
 CL.AddConstantN('AMD_BIT_24','LongWord').SetUInt( $01000000);
 CL.AddConstantN('AMD_BIT_25','LongWord').SetUInt( $02000000);
 CL.AddConstantN('AMD_BIT_26','LongWord').SetUInt( $04000000);
 CL.AddConstantN('AMD_BIT_27','LongWord').SetUInt( $08000000);
 CL.AddConstantN('AMD_BIT_28','LongWord').SetUInt( $10000000);
 CL.AddConstantN('AMD_BIT_29','LongWord').SetUInt( $20000000);
 CL.AddConstantN('AMD_BIT_30','LongWord').SetUInt( $40000000);
 CL.AddConstantN('AMD_BIT_31','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('EAMD_FPU_FLAG','LongWord').SetUInt( $00000001);
 CL.AddConstantN('EAMD_VME_FLAG','LongWord').SetUInt( $00000002);
 CL.AddConstantN('EAMD_DE_FLAG','LongWord').SetUInt( $00000004);
 CL.AddConstantN('EAMD_PSE_FLAG','LongWord').SetUInt( $00000008);
 CL.AddConstantN('EAMD_TSC_FLAG','LongWord').SetUInt( $00000010);
 CL.AddConstantN('EAMD_MSR_FLAG','LongWord').SetUInt( $00000020);
 CL.AddConstantN('EAMD_BIT_6','LongWord').SetUInt( $00000040);
 CL.AddConstantN('EAMD_MCE_FLAG','LongWord').SetUInt( $00000080);
 CL.AddConstantN('EAMD_CX8_FLAG','LongWord').SetUInt( $00000100);
 CL.AddConstantN('EAMD_BIT_9','LongWord').SetUInt( $00000200);
 CL.AddConstantN('EAMD_BIT_10','LongWord').SetUInt( $00000400);
 CL.AddConstantN('EAMD_SEP_FLAG','LongWord').SetUInt( $00000800);
 CL.AddConstantN('EAMD_BIT_12','LongWord').SetUInt( $00001000);
 CL.AddConstantN('EAMD_PGE_FLAG','LongWord').SetUInt( $00002000);
 CL.AddConstantN('EAMD_BIT_14','LongWord').SetUInt( $00004000);
 CL.AddConstantN('EAMD_ICMOV_FLAG','LongWord').SetUInt( $00008000);
 CL.AddConstantN('EAMD_FCMOV_FLAG','LongWord').SetUInt( $00010000);
 CL.AddConstantN('EAMD_BIT_17','LongWord').SetUInt( $00020000);
 CL.AddConstantN('EAMD_BIT_18','LongWord').SetUInt( $00040000);
 CL.AddConstantN('EAMD_BIT_19','LongWord').SetUInt( $00080000);
 CL.AddConstantN('EAMD_BIT_20','LongWord').SetUInt( $00100000);
 CL.AddConstantN('EAMD_BIT_21','LongWord').SetUInt( $00200000);
 CL.AddConstantN('EAMD_BIT_22','LongWord').SetUInt( $00400000);
 CL.AddConstantN('EAMD_MMX_FLAG','LongWord').SetUInt( $00800000);
 CL.AddConstantN('EAMD_BIT_24','LongWord').SetUInt( $01000000);
 CL.AddConstantN('EAMD_BIT_25','LongWord').SetUInt( $02000000);
 CL.AddConstantN('EAMD_BIT_26','LongWord').SetUInt( $04000000);
 CL.AddConstantN('EAMD_BIT_27','LongWord').SetUInt( $08000000);
 CL.AddConstantN('EAMD_BIT_28','LongWord').SetUInt( $10000000);
 CL.AddConstantN('EAMD_BIT_29','LongWord').SetUInt( $20000000);
 CL.AddConstantN('EAMD_BIT_30','LongWord').SetUInt( $40000000);
 CL.AddConstantN('EAMD_3DNOW_FLAG','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('CYRIX_FPU_FLAG','LongWord').SetUInt( $00000001);
 CL.AddConstantN('CYRIX_VME_FLAG','LongWord').SetUInt( $00000002);
 CL.AddConstantN('CYRIX_DE_FLAG','LongWord').SetUInt( $00000004);
 CL.AddConstantN('CYRIX_PSE_FLAG','LongWord').SetUInt( $00000008);
 CL.AddConstantN('CYRIX_TSC_FLAG','LongWord').SetUInt( $00000010);
 CL.AddConstantN('CYRIX_MSR_FLAG','LongWord').SetUInt( $00000020);
 CL.AddConstantN('CYRIX_PAE_FLAG','LongWord').SetUInt( $00000040);
 CL.AddConstantN('CYRIX_MCE_FLAG','LongWord').SetUInt( $00000080);
 CL.AddConstantN('CYRIX_CX8_FLAG','LongWord').SetUInt( $00000100);
 CL.AddConstantN('CYRIX_APIC_FLAG','LongWord').SetUInt( $00000200);
 CL.AddConstantN('CYRIX_BIT_10','LongWord').SetUInt( $00000400);
 CL.AddConstantN('CYRIX_BIT_11','LongWord').SetUInt( $00000800);
 CL.AddConstantN('CYRIX_MTRR_FLAG','LongWord').SetUInt( $00001000);
 CL.AddConstantN('CYRIX_PGE_FLAG','LongWord').SetUInt( $00002000);
 CL.AddConstantN('CYRIX_MCA_FLAG','LongWord').SetUInt( $00004000);
 CL.AddConstantN('CYRIX_CMOV_FLAG','LongWord').SetUInt( $00008000);
 CL.AddConstantN('CYRIX_BIT_16','LongWord').SetUInt( $00010000);
 CL.AddConstantN('CYRIX_BIT_17','LongWord').SetUInt( $00020000);
 CL.AddConstantN('CYRIX_BIT_18','LongWord').SetUInt( $00040000);
 CL.AddConstantN('CYRIX_BIT_19','LongWord').SetUInt( $00080000);
 CL.AddConstantN('CYRIX_BIT_20','LongWord').SetUInt( $00100000);
 CL.AddConstantN('CYRIX_BIT_21','LongWord').SetUInt( $00200000);
 CL.AddConstantN('CYRIX_BIT_22','LongWord').SetUInt( $00400000);
 CL.AddConstantN('CYRIX_MMX_FLAG','LongWord').SetUInt( $00800000);
 CL.AddConstantN('CYRIX_BIT_24','LongWord').SetUInt( $01000000);
 CL.AddConstantN('CYRIX_BIT_25','LongWord').SetUInt( $02000000);
 CL.AddConstantN('CYRIX_BIT_26','LongWord').SetUInt( $04000000);
 CL.AddConstantN('CYRIX_BIT_27','LongWord').SetUInt( $08000000);
 CL.AddConstantN('CYRIX_BIT_28','LongWord').SetUInt( $10000000);
 CL.AddConstantN('CYRIX_BIT_29','LongWord').SetUInt( $20000000);
 CL.AddConstantN('CYRIX_BIT_30','LongWord').SetUInt( $40000000);
 CL.AddConstantN('CYRIX_BIT_31','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('ECYRIX_FPU_FLAG','LongWord').SetUInt( $00000001);
 CL.AddConstantN('ECYRIX_VME_FLAG','LongWord').SetUInt( $00000002);
 CL.AddConstantN('ECYRIX_DE_FLAG','LongWord').SetUInt( $00000004);
 CL.AddConstantN('ECYRIX_PSE_FLAG','LongWord').SetUInt( $00000008);
 CL.AddConstantN('ECYRIX_TSC_FLAG','LongWord').SetUInt( $00000010);
 CL.AddConstantN('ECYRIX_MSR_FLAG','LongWord').SetUInt( $00000020);
 CL.AddConstantN('ECYRIX_PAE_FLAG','LongWord').SetUInt( $00000040);
 CL.AddConstantN('ECYRIX_MCE_FLAG','LongWord').SetUInt( $00000080);
 CL.AddConstantN('ECYRIX_CX8_FLAG','LongWord').SetUInt( $00000100);
 CL.AddConstantN('ECYRIX_APIC_FLAG','LongWord').SetUInt( $00000200);
 CL.AddConstantN('ECYRIX_SEP_FLAG','LongWord').SetUInt( $00000400);
 CL.AddConstantN('ECYRIX_BIT_11','LongWord').SetUInt( $00000800);
 CL.AddConstantN('ECYRIX_MTRR_FLAG','LongWord').SetUInt( $00001000);
 CL.AddConstantN('ECYRIX_PGE_FLAG','LongWord').SetUInt( $00002000);
 CL.AddConstantN('ECYRIX_MCA_FLAG','LongWord').SetUInt( $00004000);
 CL.AddConstantN('ECYRIX_ICMOV_FLAG','LongWord').SetUInt( $00008000);
 CL.AddConstantN('ECYRIX_FCMOV_FLAG','LongWord').SetUInt( $00010000);
 CL.AddConstantN('ECYRIX_BIT_17','LongWord').SetUInt( $00020000);
 CL.AddConstantN('ECYRIX_BIT_18','LongWord').SetUInt( $00040000);
 CL.AddConstantN('ECYRIX_BIT_19','LongWord').SetUInt( $00080000);
 CL.AddConstantN('ECYRIX_BIT_20','LongWord').SetUInt( $00100000);
 CL.AddConstantN('ECYRIX_BIT_21','LongWord').SetUInt( $00200000);
 CL.AddConstantN('ECYRIX_BIT_22','LongWord').SetUInt( $00400000);
 CL.AddConstantN('ECYRIX_MMX_FLAG','LongWord').SetUInt( $00800000);
 CL.AddConstantN('ECYRIX_EMMX_FLAG','LongWord').SetUInt( $01000000);
 CL.AddConstantN('ECYRIX_BIT_25','LongWord').SetUInt( $02000000);
 CL.AddConstantN('ECYRIX_BIT_26','LongWord').SetUInt( $04000000);
 CL.AddConstantN('ECYRIX_BIT_27','LongWord').SetUInt( $08000000);
 CL.AddConstantN('ECYRIX_BIT_28','LongWord').SetUInt( $10000000);
 CL.AddConstantN('ECYRIX_BIT_29','LongWord').SetUInt( $20000000);
 CL.AddConstantN('ECYRIX_BIT_30','LongWord').SetUInt( $40000000);
 CL.AddConstantN('ECYRIX_BIT_31','LongWord').SetUInt( DWORD ( $80000000 ));
 //CL.AddDelphiFunction('Procedure GetCpuInfo( var CpuInfo : TCpuInfo)');
 CL.AddDelphiFunction('Function GetIntelCacheDescription( const D : Byte) : string');
 CL.AddDelphiFunction('Function RoundFrequency( const Frequency : Integer) : Integer');
 CL.AddDelphiFunction('Function GetCPUSpeed2( var CpuSpeed : TFreqInfo) : Boolean');
 //CL.AddDelphiFunction('Function CPUID : TCpuInfo');
 CL.AddDelphiFunction('Function TestFDIVInstruction : Boolean');
 CL.AddDelphiFunction('Function GetMaxAppAddress : Integer');
 CL.AddDelphiFunction('Function GetMinAppAddress : Integer');
 CL.AddDelphiFunction('Function GetMemoryLoad : Byte');
 CL.AddDelphiFunction('Function GetSwapFileSize : Integer');
 CL.AddDelphiFunction('Function GetSwapFileUsage : Integer');
 CL.AddDelphiFunction('Function GetTotalPhysicalMemory : Integer');
 CL.AddDelphiFunction('Function GetFreePhysicalMemory : Integer');
 CL.AddDelphiFunction('Function GetTotalPageFileMemory : Integer');
 CL.AddDelphiFunction('Function GetFreePageFileMemory : Integer');
 CL.AddDelphiFunction('Function GetTotalVirtualMemory : Integer');
 CL.AddDelphiFunction('Function GetFreeVirtualMemory : Integer');
 CL.AddDelphiFunction('Procedure RoundToAllocGranularity64( var Value : Int64; Up : Boolean)');
 //CL.AddDelphiFunction('Procedure RoundToAllocGranularityPtr( var Value : ___Pointer; Up : Boolean)');
 CL.AddDelphiFunction('Function GetKeyState( const VirtualKey : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function GetNumLockKeyState : Boolean');
 CL.AddDelphiFunction('Function GetScrollLockKeyState : Boolean');
 CL.AddDelphiFunction('Function GetCapsLockKeyState : Boolean');
  CL.AddTypeS('TFreeSysResKind', '( rtSystem, rtGdi, rtUser )');
  CL.AddTypeS('TFreeSystemResources', 'record SystemRes : integer; GdiRes : int'
   +'eger; UserRes : Integer; end');
 CL.AddDelphiFunction('Function IsSystemResourcesMeterPresent : Boolean');
 CL.AddDelphiFunction('Function GetFreeSystemResources( const ResourceType : TFreeSysResKind) : Integer;');
 CL.AddDelphiFunction('Function GetFreeSystemResources1 : TFreeSystemResources;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function GetFreeSystemResources1_P : TFreeSystemResources;
Begin Result := JclSysInfo.GetFreeSystemResources; END;

(*----------------------------------------------------------------------------*)
Function GetFreeSystemResources_P( const ResourceType : TFreeSysResKind) : Integer;
Begin Result := JclSysInfo.GetFreeSystemResources(ResourceType); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclSysInfo_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DelEnvironmentVar, 'DelEnvironmentVar', cdRegister);
 S.RegisterDelphiFunction(@ExpandEnvironmentVar, 'ExpandEnvironmentVar', cdRegister);
 S.RegisterDelphiFunction(@GetEnvironmentVar, 'GetEnvironmentVar', cdRegister);
 S.RegisterDelphiFunction(@GetEnvironmentVars, 'GetEnvironmentVars', cdRegister);
 S.RegisterDelphiFunction(@SetEnvironmentVar, 'SetEnvironmentVar', cdRegister);
 S.RegisterDelphiFunction(@CreateEnvironmentBlock, 'CreateEnvironmentBlock', cdRegister);
 S.RegisterDelphiFunction(@GetCommonFilesFolder, 'GetCommonFilesFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentFolder, 'GetCurrentFolder', cdRegister);
 S.RegisterDelphiFunction(@GetProgramFilesFolder, 'GetProgramFilesFolder', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsFolder, 'GetWindowsFolder', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsSystemFolder, 'GetWindowsSystemFolder', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsTempFolder, 'GetWindowsTempFolder', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopFolder, 'GetDesktopFolder', cdRegister);
 S.RegisterDelphiFunction(@GetProgramsFolder, 'GetProgramsFolder', cdRegister);
 S.RegisterDelphiFunction(@GetPersonalFolder, 'GetPersonalFolder', cdRegister);
 S.RegisterDelphiFunction(@GetFavoritesFolder, 'GetFavoritesFolder', cdRegister);
 S.RegisterDelphiFunction(@GetStartupFolder, 'GetStartupFolder', cdRegister);
 S.RegisterDelphiFunction(@GetRecentFolder, 'GetRecentFolder', cdRegister);
 S.RegisterDelphiFunction(@GetSendToFolder, 'GetSendToFolder', cdRegister);
 S.RegisterDelphiFunction(@GetStartmenuFolder, 'GetStartmenuFolder', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopDirectoryFolder, 'GetDesktopDirectoryFolder', cdRegister);
 S.RegisterDelphiFunction(@GetNethoodFolder, 'GetNethoodFolder', cdRegister);
 S.RegisterDelphiFunction(@GetFontsFolder, 'GetFontsFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCommonStartmenuFolder, 'GetCommonStartmenuFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCommonProgramsFolder, 'GetCommonProgramsFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCommonStartupFolder, 'GetCommonStartupFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCommonDesktopdirectoryFolder, 'GetCommonDesktopdirectoryFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCommonAppdataFolder, 'GetCommonAppdataFolder', cdRegister);
 S.RegisterDelphiFunction(@GetAppdataFolder, 'GetAppdataFolder', cdRegister);
 S.RegisterDelphiFunction(@GetPrinthoodFolder, 'GetPrinthoodFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCommonFavoritesFolder, 'GetCommonFavoritesFolder', cdRegister);
 S.RegisterDelphiFunction(@GetTemplatesFolder, 'GetTemplatesFolder', cdRegister);
 S.RegisterDelphiFunction(@GetInternetCacheFolder, 'GetInternetCacheFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCookiesFolder, 'GetCookiesFolder', cdRegister);
 S.RegisterDelphiFunction(@GetHistoryFolder, 'GetHistoryFolder', cdRegister);
 S.RegisterDelphiFunction(@GetAPMLineStatus, 'GetAPMLineStatus', cdRegister);
 S.RegisterDelphiFunction(@GetAPMBatteryFlag, 'GetAPMBatteryFlag', cdRegister);
 S.RegisterDelphiFunction(@GetAPMBatteryLifePercent, 'GetAPMBatteryLifePercent', cdRegister);
 S.RegisterDelphiFunction(@GetAPMBatteryLifeTime, 'GetAPMBatteryLifeTime', cdRegister);
 S.RegisterDelphiFunction(@GetAPMBatteryFullLifeTime, 'GetAPMBatteryFullLifeTime', cdRegister);
 S.RegisterDelphiFunction(@GetVolumeName, 'GetVolumeName', cdRegister);
 S.RegisterDelphiFunction(@GetVolumeSerialNumber, 'GetVolumeSerialNumber', cdRegister);
 S.RegisterDelphiFunction(@GetVolumeFileSystem, 'GetVolumeFileSystem', cdRegister);
 S.RegisterDelphiFunction(@GetIPAddress, 'GetIPAddress', cdRegister);
  S.RegisterDelphiFunction(@GetIPAddresses, 'GetIPAddresses', cdRegister);
  S.RegisterDelphiFunction(@GetIPAddresses, 'GetIPs', cdRegister);

 S.RegisterDelphiFunction(@GetIPAddress, 'GetIP', cdRegister);
 S.RegisterDelphiFunction(@GetLocalComputerName, 'GetLocalComputerName', cdRegister);
 S.RegisterDelphiFunction(@GetLocalUserName, 'GetLocalUserName', cdRegister);
 S.RegisterDelphiFunction(@GetUserDomainName, 'GetUserDomainName', cdRegister);
 S.RegisterDelphiFunction(@GetDomainName, 'GetDomainName', cdRegister);
 S.RegisterDelphiFunction(@GetRegisteredCompany, 'GetRegisteredCompany', cdRegister);
 S.RegisterDelphiFunction(@GetRegisteredOwner, 'GetRegisteredOwner', cdRegister);
 S.RegisterDelphiFunction(@GetBIOSName, 'GetBIOSName', cdRegister);
 S.RegisterDelphiFunction(@GetBIOSCopyright, 'GetBIOSCopyright', cdRegister);
 S.RegisterDelphiFunction(@GetBIOSExtendedInfo, 'GetBIOSExtendedInfo', cdRegister);
 S.RegisterDelphiFunction(@GetBIOSDate, 'GetBIOSDate', cdRegister);
 S.RegisterDelphiFunction(@RunningProcessesList, 'RunningProcessesList', cdRegister);
 S.RegisterDelphiFunction(@LoadedModulesList, 'LoadedModulesList', cdRegister);
 S.RegisterDelphiFunction(@GetTasksList, 'GetTasksList', cdRegister);
 //S.RegisterDelphiFunction(@ModuleFromAddr, 'ModuleFromAddr', cdRegister);
 S.RegisterDelphiFunction(@IsSystemModule, 'IsSystemModule', cdRegister);
 S.RegisterDelphiFunction(@IsMainAppWindow, 'IsMainAppWindow', cdRegister);
 S.RegisterDelphiFunction(@IsWindowResponding, 'IsWindowResponding', cdRegister);
 S.RegisterDelphiFunction(@GetWindowIcon, 'GetWindowIcon', cdRegister);
 S.RegisterDelphiFunction(@GetWindowCaption, 'GetWindowCaption', cdRegister);
 S.RegisterDelphiFunction(@TerminateTask, 'TerminateTask', cdRegister);
 S.RegisterDelphiFunction(@TerminateApp, 'TerminateApp', cdRegister);
 S.RegisterDelphiFunction(@GetPidFromProcessName, 'GetPidFromProcessName', cdRegister);
 S.RegisterDelphiFunction(@GetProcessNameFromWnd, 'GetProcessNameFromWnd', cdRegister);
 S.RegisterDelphiFunction(@GetProcessNameFromPid, 'GetProcessNameFromPid', cdRegister);
 S.RegisterDelphiFunction(@GetMainAppWndFromPid, 'GetMainAppWndFromPid', cdRegister);
 S.RegisterDelphiFunction(@GetShellProcessName, 'GetShellProcessName', cdRegister);
 S.RegisterDelphiFunction(@GetShellProcessHandle, 'GetShellProcessHandle', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsVersion, 'GetWindowsVersion', cdRegister);
 S.RegisterDelphiFunction(@NtProductType, 'NtProductType', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsVersionString, 'GetWindowsVersionString', cdRegister);
 S.RegisterDelphiFunction(@NtProductTypeString, 'NtProductTypeString', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsServicePackVersion, 'GetWindowsServicePackVersion', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsServicePackVersionString, 'GetWindowsServicePackVersionString', cdRegister);
 S.RegisterDelphiFunction(@GetMacAddresses, 'GetMacAddresses', cdRegister);
 S.RegisterDelphiFunction(@ReadTimeStampCounter, 'ReadTimeStampCounter', cdRegister);
 //S.RegisterDelphiFunction(@GetCpuInfo, 'GetCpuInfo', cdRegister);
 S.RegisterDelphiFunction(@GetIntelCacheDescription, 'GetIntelCacheDescription', cdRegister);
 S.RegisterDelphiFunction(@RoundFrequency, 'RoundFrequency', cdRegister);
 S.RegisterDelphiFunction(@GetCPUSpeed, 'GetCPUSpeed2', cdRegister);
 //S.RegisterDelphiFunction(@CPUID, 'CPUID', cdRegister);
 S.RegisterDelphiFunction(@TestFDIVInstruction, 'TestFDIVInstruction', cdRegister);
 S.RegisterDelphiFunction(@GetMaxAppAddress, 'GetMaxAppAddress', cdRegister);
 S.RegisterDelphiFunction(@GetMinAppAddress, 'GetMinAppAddress', cdRegister);
 S.RegisterDelphiFunction(@GetMemoryLoad, 'GetMemoryLoad', cdRegister);
 S.RegisterDelphiFunction(@GetSwapFileSize, 'GetSwapFileSize', cdRegister);
 S.RegisterDelphiFunction(@GetSwapFileUsage, 'GetSwapFileUsage', cdRegister);
 S.RegisterDelphiFunction(@GetTotalPhysicalMemory, 'GetTotalPhysicalMemory', cdRegister);
 S.RegisterDelphiFunction(@GetFreePhysicalMemory, 'GetFreePhysicalMemory', cdRegister);
 S.RegisterDelphiFunction(@GetTotalPageFileMemory, 'GetTotalPageFileMemory', cdRegister);
 S.RegisterDelphiFunction(@GetFreePageFileMemory, 'GetFreePageFileMemory', cdRegister);
 S.RegisterDelphiFunction(@GetTotalVirtualMemory, 'GetTotalVirtualMemory', cdRegister);
 S.RegisterDelphiFunction(@GetFreeVirtualMemory, 'GetFreeVirtualMemory', cdRegister);
 S.RegisterDelphiFunction(@RoundToAllocGranularity64, 'RoundToAllocGranularity64', cdRegister);
 //S.RegisterDelphiFunction(@RoundToAllocGranularityPtr, 'RoundToAllocGranularityPtr', cdRegister);
 S.RegisterDelphiFunction(@GetKeyState, 'GetKeyState', cdRegister);
 S.RegisterDelphiFunction(@GetNumLockKeyState, 'GetNumLockKeyState', cdRegister);
 S.RegisterDelphiFunction(@GetScrollLockKeyState, 'GetScrollLockKeyState', cdRegister);
 S.RegisterDelphiFunction(@GetCapsLockKeyState, 'GetCapsLockKeyState', cdRegister);
 S.RegisterDelphiFunction(@IsSystemResourcesMeterPresent, 'IsSystemResourcesMeterPresent', cdRegister);
 S.RegisterDelphiFunction(@GetFreeSystemResources, 'GetFreeSystemResources', cdRegister);
 S.RegisterDelphiFunction(@GetFreeSystemResources1_P, 'GetFreeSystemResources1', cdRegister);
end;

 
 
{ TPSImport_JclSysInfo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSysInfo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclSysInfo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSysInfo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclSysInfo(ri);
  RIRegister_JclSysInfo_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 

end.
