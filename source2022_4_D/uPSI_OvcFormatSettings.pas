unit uPSI_OvcFormatSettings;
{
  just one big rec function
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
  TPSImport_OvcFormatSettings = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_OvcFormatSettings(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_OvcFormatSettings_Routines(S: TPSExec);

procedure Register;

implementation


uses
   OvcFormatSettings
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OvcFormatSettings]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_OvcFormatSettings(CL: TPSPascalCompiler);
begin
CL.AddConstantN('SECTION_QUERY','LongInt').SetInt( 1);
 CL.AddConstantN('SECTION_MAP_WRITE','LongInt').SetInt( 2);
 CL.AddConstantN('SECTION_MAP_READ','LongInt').SetInt( 4);
 CL.AddConstantN('SECTION_MAP_EXECUTE','LongInt').SetInt( 8);
 CL.AddConstantN('SECTION_EXTEND_SIZE','LongWord').SetUInt( $10);
 CL.AddConstantN('PAGE_NOACCESS','LongInt').SetInt( 1);
 CL.AddConstantN('PAGE_READONLY','LongInt').SetInt( 2);
 CL.AddConstantN('PAGE_READWRITE','LongInt').SetInt( 4);
 CL.AddConstantN('PAGE_WRITECOPY','LongInt').SetInt( 8);
 CL.AddConstantN('PAGE_EXECUTE','LongWord').SetUInt( $10);
 CL.AddConstantN('PAGE_EXECUTE_READ','LongWord').SetUInt( $20);
 CL.AddConstantN('PAGE_EXECUTE_READWRITE','LongWord').SetUInt( $40);
 CL.AddConstantN('PAGE_EXECUTE_WRITECOPY','LongWord').SetUInt( $80);
 CL.AddConstantN('PAGE_GUARD','LongWord').SetUInt( $100);
 CL.AddConstantN('PAGE_NOCACHE','LongWord').SetUInt( $200);
 CL.AddConstantN('MEM_COMMIT','LongWord').SetUInt( $1000);
 CL.AddConstantN('MEM_RESERVE','LongWord').SetUInt( $2000);
 CL.AddConstantN('MEM_DECOMMIT','LongWord').SetUInt( $4000);
 CL.AddConstantN('MEM_RELEASE','LongWord').SetUInt( $8000);
 CL.AddConstantN('MEM_FREE','LongWord').SetUInt( $10000);
 CL.AddConstantN('MEM_PRIVATE','LongWord').SetUInt( $20000);
 CL.AddConstantN('MEM_MAPPED','LongWord').SetUInt( $40000);
 CL.AddConstantN('MEM_RESET','LongWord').SetUInt( $80000);
 CL.AddConstantN('MEM_TOP_DOWN','LongWord').SetUInt( $100000);
 CL.AddConstantN('SEC_FILE','LongWord').SetUInt( $800000);
 CL.AddConstantN('SEC_IMAGE','LongWord').SetUInt( $1000000);
 CL.AddConstantN('SEC_RESERVE','LongWord').SetUInt( $4000000);
 CL.AddConstantN('SEC_COMMIT','LongWord').SetUInt( $8000000);
 CL.AddConstantN('SEC_NOCACHE','LongWord').SetUInt( $10000000);
 CL.AddConstantN('MEM_IMAGE','longword').SetUint( $1000000);
  CL.AddConstantN('OWNER_SECURITY_INFORMATION','LongWord').SetUInt( $00000001);
 CL.AddConstantN('GROUP_SECURITY_INFORMATION','LongWord').SetUInt( $00000002);
 CL.AddConstantN('DACL_SECURITY_INFORMATION','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SACL_SECURITY_INFORMATION','LongWord').SetUInt( $00000008);
 CL.AddConstantN('IMAGE_DOS_SIGNATURE','LongWord').SetUInt( $5A4D);
 CL.AddConstantN('IMAGE_OS2_SIGNATURE','LongWord').SetUInt( $454E);
 CL.AddConstantN('IMAGE_OS2_SIGNATURE_LE','LongWord').SetUInt( $454C);
 CL.AddConstantN('IMAGE_VXD_SIGNATURE','LongWord').SetUInt( $454C);
 CL.AddConstantN('IMAGE_NT_SIGNATURE','LongWord').SetUInt( $00004550);


 CL.AddDelphiFunction('Function ovFormatSettings : TFormatSettings');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_OvcFormatSettings_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FormatSettings, 'ovFormatSettings', cdRegister);
end;

 
 
{ TPSImport_OvcFormatSettings }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OvcFormatSettings.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OvcFormatSettings(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OvcFormatSettings.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_OvcFormatSettings(ri);
  RIRegister_OvcFormatSettings_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
