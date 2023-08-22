unit uPSI_TlHelp32;
{
  last for threads services before  , toolhelp
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
  TPSImport_TlHelp32 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TlHelp32(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TlHelp32_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,TlHelp32
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TlHelp32]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TlHelp32(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MAX_MODULE_NAME32','LongInt').SetInt( 255);
 CL.AddDelphiFunction('Function CreateToolhelp32Snapshot( dwFlags, th32ProcessID : DWORD) : THandle');
 CL.AddConstantN('TH32CS_SNAPHEAPLIST','LongWord').SetUInt( $00000001);
 CL.AddConstantN('TH32CS_SNAPPROCESS','LongWord').SetUInt( $00000002);
 CL.AddConstantN('TH32CS_SNAPTHREAD','LongWord').SetUInt( $00000004);
 CL.AddConstantN('TH32CS_SNAPMODULE','LongWord').SetUInt( $00000008);
 CL.AddConstantN('TH32CS_SNAPALL','LongWord').SetUInt($00000001 OR $00000002 OR $00000004 OR $00000008);

   // = TH32CS_SNAPHEAPLIST or TH32CS_SNAPPROCESS or
   // TH32CS_SNAPTHREAD or TH32CS_SNAPMODULE;

 CL.AddConstantN('TH32CS_INHERIT','LongWord').SetUInt( $80000000);
  CL.AddTypeS('tagHEAPLIST32', 'record dwSize : DWORD; th32ProcessID : DWORD; th32HeapID : DWORD; dwFlags : DWORD; end');
  CL.AddTypeS('HEAPLIST32', 'tagHEAPLIST32');

  {tagPROCESSENTRY32 = packed record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ProcessID: DWORD;       // this process
    th32DefaultHeapID: DWORD;
    th32ModuleID: DWORD;        // associated exe
    cntThreads: DWORD;
    th32ParentProcessID: DWORD; // this process's parent process
    pcPriClassBase: Longint;    // Base priority of process's threads
    dwFlags: DWORD;
    szExeFile: array[0..MAX_PATH - 1] of Char;// Path
  end; }

   {tagTHREADENTRY32 = record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ThreadID: DWORD;       // this thread
    th32OwnerProcessID: DWORD; // Process this thread is associated with
    tpBasePri: Longint;
    tpDeltaPri: Longint;
    dwFlags: DWORD;
  end;}

 {  tagMODULEENTRY32 = record
    dwSize: DWORD;
    th32ModuleID: DWORD;  // This module
    th32ProcessID: DWORD; // owning process
    GlblcntUsage: DWORD;  // Global usage count on the module
    ProccntUsage: DWORD;  // Module usage count in th32ProcessID's context
    modBaseAddr: PBYTE;   // Base address of module in th32ProcessID's context
    modBaseSize: DWORD;   // Size in bytes of module starting at modBaseAddr
    hModule: HMODULE;     // The hModule of this module in th32ProcessID's context
    szModule: array[0..MAX_MODULE_NAME32] of Char;
    szExePath: array[0..MAX_PATH - 1] of Char;
  end; }

   CL.AddTypeS('tagProcessEntry32', 'record dwSize : DWORD; cntUsage: DWORD; th32ProcessID : DWORD;'+
   'th32DefaultHeapID: DWORD; th32ModuleID: DWORD; cntThreads: DWORD;'+
   'th32ParentProcessID: DWORD; pcPriClassBase: Longint;  dwFlags : DWORD; szExeFile: array[0..MAX_PATH - 1] of Char; end');

    CL.AddTypeS('tagMODULEENTRY32', 'record dwSize : DWORD; th32ModuleID: DWORD; th32ProcessID : DWORD;'+
   'GlblcntUsage: DWORD; ProccntUsage: DWORD; modBaseAddr: BYTE; modBaseSize: DWORD;'+
   'hModule: HModule; szModule: array[0..255] of Char; szExePath: array[0..MAX_PATH - 1] of Char; end');

   CL.AddTypeS('tagTHREADENTRY32', 'record dwSize : DWORD; cntUsage: DWORD; th32ThreadID : DWORD;'+
   'th32OwnerProcessID: DWORD; tpBasePri: Longint; tpDeltaPri: Longint; dwFlags : DWORD; end');

  CL.AddTypeS('PROCESSENTRY32', 'tagPROCESSENTRY32');
  CL.AddTypeS('TProcessEntry32','tagPROCESSENTRY32');
  CL.AddTypeS('MODULEENTRY32', 'tagMODULEENTRY32');
  CL.AddTypeS('TModuleEntry32','tagMODULEENTRY32');
  CL.AddTypeS('TThreadEntry32','tagTHREADENTRY32');
  CL.AddTypeS('THREADENTRY32','tagTHREADENTRY32');

   //THREADENTRY32 = tagTHREADENTRY32;
   //TThreadEntry32 = tagTHREADENTRY32;

 CL.AddDelphiFunction('Function Process32First( hSnapshot : THandle; var lppe : TProcessEntry32) : BOOL');
 CL.AddDelphiFunction('Function Process32Next( hSnapshot : THandle; var lppe : TProcessEntry32) : BOOL');

 // CL.AddTypeS('PHEAPLIST32', '^tagHEAPLIST32 // will not work');
 // CL.AddTypeS('LPHEAPLIST32', '^tagHEAPLIST32 // will not work');
  CL.AddTypeS('THeapList32', 'tagHEAPLIST32');
 CL.AddConstantN('HF32_DEFAULT','LongInt').SetInt( 1);
 CL.AddConstantN('HF32_SHARED','LongInt').SetInt( 2);
 CL.AddDelphiFunction('Function Heap32ListFirst( hSnapshot : THandle; var lphl : THeapList32) : BOOL');
 CL.AddDelphiFunction('Function Heap32ListNext( hSnapshot : THandle; var lphl : THeapList32) : BOOL');
  CL.AddTypeS('tagHEAPENTRY32', 'record dwSize : DWORD; hHandle : THandle; dwAd'
   +'dress : DWORD; dwBlockSize : DWORD; dwFlags : DWORD; dwLockCount : DWORD; '
   +'dwResvd : DWORD; th32ProcessID : DWORD; th32HeapID : DWORD; end');
  CL.AddTypeS('HEAPENTRY32', 'tagHEAPENTRY32');
  //CL.AddTypeS('PHEAPENTRY32', '^tagHEAPENTRY32 // will not work');
  //CL.AddTypeS('LPHEAPENTRY32', '^tagHEAPENTRY32 // will not work');
  CL.AddTypeS('THeapEntry32', 'tagHEAPENTRY32');
 CL.AddConstantN('LF32_FIXED','LongWord').SetUInt( $00000001);
 CL.AddConstantN('LF32_FREE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('LF32_MOVEABLE','LongWord').SetUInt( $00000004);
 CL.AddDelphiFunction('Function Heap32First( var lphe : THeapEntry32; th32ProcessID, th32HeapID : DWORD) : BOOL');
 CL.AddDelphiFunction('Function Heap32Next( var lphe : THeapEntry32) : BOOL');
// CL.AddDelphiFunction('Function Toolhelp32ReadProcessMemory( th32ProcessID : DWORD; lpBaseAddress : Pointer; var lpBuffer, cbRead : DWORD; var lpNumberOfBytesRead : DWORD) : BOOL');
 // CL.AddTypeS('PROCESSENTRY32W', 'tagPROCESSENTRY32W');
 // CL.AddTypeS('PPROCESSENTRY32W', '^tagPROCESSENTRY32W // will not work');
 // CL.AddTypeS('LPPROCESSENTRY32W', '^tagPROCESSENTRY32W // will not work');
 // CL.AddTypeS('TProcessEntry32W', 'tagPROCESSENTRY32W');
// CL.AddDelphiFunction('Function Process32FirstW( hSnapshot : THandle; var lppe : TProcessEntry32W) : BOOL');
 //CL.AddDelphiFunction('Function Process32NextW( hSnapshot : THandle; var lppe : TProcessEntry32W) : BOOL');
 // CL.AddTypeS('PROCESSENTRY32', 'tagPROCESSENTRY32');
 // CL.AddTypeS('PPROCESSENTRY32', '^tagPROCESSENTRY32 // will not work');
 // CL.AddTypeS('LPPROCESSENTRY32', '^tagPROCESSENTRY32 // will not work');
 // CL.AddTypeS('TProcessEntry32', 'tagPROCESSENTRY32');
 //CL.AddDelphiFunction('Function Process32First( hSnapshot : THandle; var lppe : TProcessEntry32) : BOOL');
 //CL.AddDelphiFunction('Function Process32Next( hSnapshot : THandle; var lppe : TProcessEntry32) : BOOL');
  CL.AddTypeS('tagTHREADENTRY32', 'record dwSize : DWORD; cntUsage : DWORD; th3'
   +'2ThreadID : DWORD; th32OwnerProcessID : DWORD; tpBasePri : Longint; tpDelt'
   +'aPri : Longint; dwFlags : DWORD; end');
  CL.AddTypeS('THREADENTRY32', 'tagTHREADENTRY32');
 // CL.AddTypeS('PTHREADENTRY32', '^tagTHREADENTRY32 // will not work');
 // CL.AddTypeS('LPTHREADENTRY32', '^tagTHREADENTRY32 // will not work');
  CL.AddTypeS('TThreadEntry32', 'tagTHREADENTRY32');
 CL.AddDelphiFunction('Function Thread32First( hSnapshot : THandle; var lpte : TThreadEntry32) : BOOL');
 CL.AddDelphiFunction('Function Thread32Next( hSnapshot : THandle; var lpte : TThreadENtry32) : BOOL');
 // CL.AddTypeS('MODULEENTRY32', 'tagMODULEENTRY32');
 // CL.AddTypeS('PMODULEENTRY32', '^tagMODULEENTRY32 // will not work');
 // CL.AddTypeS('LPMODULEENTRY32', '^tagMODULEENTRY32 // will not work');
 // CL.AddTypeS('TModuleEntry32', 'tagMODULEENTRY32');
 //CL.AddDelphiFunction('Function Module32First( hSnapshot : THandle; var lpme : TModuleEntry32) : BOOL');
 //CL.AddDelphiFunction('Function Module32Next( hSnapshot : THandle; var lpme : TModuleEntry32) : BOOL');
 // CL.AddTypeS('MODULEENTRY32W', 'tagMODULEENTRY32W');
 // CL.AddTypeS('PMODULEENTRY32W', '^tagMODULEENTRY32W // will not work');
 // CL.AddTypeS('LPMODULEENTRY32W', '^tagMODULEENTRY32W // will not work');
 // CL.AddTypeS('TModuleEntry32W', 'tagMODULEENTRY32W');
 //CL.AddDelphiFunction('Function Module32FirstW( hSnapshot : THandle; var lpme : TModuleEntry32W) : BOOL');
 //CL.AddDelphiFunction('Function Module32NextW( hSnapshot : THandle; var lpme : TModuleEntry32W) : BOOL');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TlHelp32_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateToolhelp32Snapshot, 'CreateToolhelp32Snapshot', cdRegister);
 S.RegisterDelphiFunction(@Heap32ListFirst, 'Heap32ListFirst', cdRegister);
 S.RegisterDelphiFunction(@Heap32ListNext, 'Heap32ListNext', cdRegister);
 S.RegisterDelphiFunction(@Heap32First, 'Heap32First', cdRegister);
 S.RegisterDelphiFunction(@Heap32Next, 'Heap32Next', cdRegister);
 S.RegisterDelphiFunction(@Toolhelp32ReadProcessMemory, 'Toolhelp32ReadProcessMemory', cdRegister);
 S.RegisterDelphiFunction(@Process32FirstW, 'Process32FirstW', cdRegister);
 S.RegisterDelphiFunction(@Process32NextW, 'Process32NextW', cdRegister);
 S.RegisterDelphiFunction(@Process32First, 'Process32First', cdRegister);
 S.RegisterDelphiFunction(@Process32Next, 'Process32Next', cdRegister);
 S.RegisterDelphiFunction(@Thread32First, 'Thread32First', CdStdCall);
 S.RegisterDelphiFunction(@Thread32Next, 'Thread32Next', CdStdCall);
 S.RegisterDelphiFunction(@Module32First, 'Module32First', cdRegister);
 S.RegisterDelphiFunction(@Module32Next, 'Module32Next', cdRegister);
 S.RegisterDelphiFunction(@Module32FirstW, 'Module32FirstW', cdRegister);
 S.RegisterDelphiFunction(@Module32NextW, 'Module32NextW', cdRegister);
end;

 
 
{ TPSImport_TlHelp32 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TlHelp32.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TlHelp32(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TlHelp32.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_TlHelp32(ri);
  RIRegister_TlHelp32_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
