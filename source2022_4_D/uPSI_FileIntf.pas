unit uPSI_FileIntf;
{
   experimental  intf
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
  TPSImport_FileIntf = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIVirtualFileSystem(CL: TPSPascalCompiler);
procedure SIRegister_FileIntf(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIVirtualFileSystem(CL: TPSRuntimeClassImporter);
procedure RIRegister_FileIntf(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ActiveX
  ,VirtIntf
  ,FileIntf
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FileIntf]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIVirtualFileSystem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterface', 'TIVirtualFileSystem') do
  with CL.AddClassN(CL.FindClass('TInterface'),'TIVirtualFileSystem') do begin
    RegisterMethod('Function GetFileStream( const FileName : TFileName; Mode : Integer) : IStream');
    RegisterMethod('Function FileAge( const FileName : TFileName) : Longint');
    RegisterMethod('Function RenameFile( const OldName, NewName : TFileName) : Boolean');
    RegisterMethod('Function IsReadonly( const FileName : TFileName) : Boolean');
    RegisterMethod('Function IsFileBased : Boolean');
    RegisterMethod('Function DeleteFile( const FileName : TFileName) : Boolean');
    RegisterMethod('Function FileExists( const FileName : TFileName) : Boolean');
    RegisterMethod('Function GetTempFileName( const FileName : TFileName) : TFileName');
    RegisterMethod('Function GetBackupFileName( const FileName : TFileName) : TFileName');
    RegisterMethod('Function GetIDString : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FileIntf(CL: TPSPascalCompiler);
begin
  SIRegister_TIVirtualFileSystem(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIVirtualFileSystem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIVirtualFileSystem) do
  begin
    RegisterVirtualMethod(@TIVirtualFileSystem.GetFileStream, 'GetFileStream');
    RegisterVirtualMethod(@TIVirtualFileSystem.FileAge, 'FileAge');
    RegisterVirtualMethod(@TIVirtualFileSystem.RenameFile, 'RenameFile');
    RegisterVirtualMethod(@TIVirtualFileSystem.IsReadonly, 'IsReadonly');
    RegisterVirtualMethod(@TIVirtualFileSystem.IsFileBased, 'IsFileBased');
    RegisterVirtualMethod(@TIVirtualFileSystem.DeleteFile, 'DeleteFile');
    RegisterVirtualMethod(@TIVirtualFileSystem.FileExists, 'FileExists');
    RegisterVirtualMethod(@TIVirtualFileSystem.GetTempFileName, 'GetTempFileName');
    RegisterVirtualMethod(@TIVirtualFileSystem.GetBackupFileName, 'GetBackupFileName');
    RegisterVirtualMethod(@TIVirtualFileSystem.GetIDString, 'GetIDString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FileIntf(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIVirtualFileSystem(CL);
end;

 
 
{ TPSImport_FileIntf }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileIntf.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FileIntf(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileIntf.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FileIntf(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
