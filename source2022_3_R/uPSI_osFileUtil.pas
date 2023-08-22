unit uPSI_osFileUtil;
{
    linux or unix windows cloud atlas

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
  TPSImport_osFileUtil = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_osFileUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_osFileUtil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   osFileUtil
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_osFileUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_osFileUtil(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function OsDOS2UnixFileAttributes( Attr : LongWord) : LongWord');
 CL.AddDelphiFunction('Function OsUnix2DosFileAttributes( Attr : LongWord) : LongWord');
 CL.AddDelphiFunction('Function OsUnixFileTimeToDateTime( UnixTime : LongInt) : TDateTime');
 CL.AddDelphiFunction('Function OsDateTimeToUnixFileTime( DateTime : TDateTime) : LongInt');
 CL.AddDelphiFunction('Function OsDosFileTimeToDateTime( DosTime : LongInt) : TDateTime');
 CL.AddDelphiFunction('Function OsDateTimeToDosFileTime( Value : TDateTime) : LongInt');
 CL.AddDelphiFunction('Function OsFileTimeToLocalFileTime( FileTime : LongInt) : LongInt');
 CL.AddDelphiFunction('Function OsLocalFileTimeToFileTime( FileTime : LongInt) : LongInt');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_osFileUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@OsDOS2UnixFileAttributes, 'OsDOS2UnixFileAttributes', cdRegister);
 S.RegisterDelphiFunction(@OsUnix2DosFileAttributes, 'OsUnix2DosFileAttributes', cdRegister);
 S.RegisterDelphiFunction(@OsUnixFileTimeToDateTime, 'OsUnixFileTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@OsDateTimeToUnixFileTime, 'OsDateTimeToUnixFileTime', cdRegister);
 S.RegisterDelphiFunction(@OsDosFileTimeToDateTime, 'OsDosFileTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@OsDateTimeToDosFileTime, 'OsDateTimeToDosFileTime', cdRegister);
 S.RegisterDelphiFunction(@OsFileTimeToLocalFileTime, 'OsFileTimeToLocalFileTime', cdRegister);
 S.RegisterDelphiFunction(@OsLocalFileTimeToFileTime, 'OsLocalFileTimeToFileTime', cdRegister);
end;

 
 
{ TPSImport_osFileUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_osFileUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_osFileUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_osFileUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_osFileUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
