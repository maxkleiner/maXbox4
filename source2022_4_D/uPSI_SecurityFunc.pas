unit uPSI_SecurityFunc;
{
   just two func
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
  TPSImport_SecurityFunc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_SecurityFunc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SecurityFunc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,CmnFunc2
  ,Struct
  ,SecurityFunc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SecurityFunc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SecurityFunc(CL: TPSPascalCompiler);
begin


{_SID_IDENTIFIER_AUTHORITY = record
    Value: array[0..5] of Byte;
  end; }

   CL.AddTypeS('_SID_IDENTIFIER_AUTHORITY',
    'record' +
    '  Value: array[0..5] of Byte;' +
    'end');

 CL.AddTypeS('TSIDIdentifierAuthority', '_SID_IDENTIFIER_AUTHORITY');
  CL.AddTypeS('SID_IDENTIFIER_AUTHORITY', '_SID_IDENTIFIER_AUTHORITY');

  (*  TGrantPermissionSid = record  { must keep in synch with Helper.c }
    Authority: TSIDIdentifierAuthority;
    SubAuthCount: Byte;
    SubAuth: array[0..1] of DWORD;
  end;*)

    CL.AddTypeS('TGrantPermissionSid',
    'record' +
    '  Authority: TSIDIdentifierAuthority;' +
    '  SubAuthCount: Byte;' +
    '  SubAuth: array[0..1] of DWORD;' +
    'end');

 (* TGrantPermissionEntry = record  { must keep in synch with Helper.c }
    Sid: TGrantPermissionSid;
    AccessMask: DWORD;
  end; *)
    CL.AddTypeS('TGrantPermissionEntry',
    'record' +
    '  Sid: TGrantPermissionSid;' +
    '  AccessMask: DWord;' +
    'end');


 CL.AddDelphiFunction('Function GrantPermissionOnFile( const DisableFsRedir : Boolean; Filename : String; const Entries : TGrantPermissionEntry; const EntryCount : Integer) : Boolean');
 CL.AddDelphiFunction('Function GrantPermissionOnKey( const RegView : TRegView; const RootKey : HKEY; const Subkey : String; const Entries : TGrantPermissionEntry; const EntryCount : Integer) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_SecurityFunc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GrantPermissionOnFile, 'GrantPermissionOnFile', cdRegister);
 S.RegisterDelphiFunction(@GrantPermissionOnKey, 'GrantPermissionOnKey', cdRegister);
end;

 
 
{ TPSImport_SecurityFunc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SecurityFunc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SecurityFunc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SecurityFunc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_SecurityFunc(ri);
  RIRegister_SecurityFunc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
