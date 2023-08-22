unit uPSI_ALFcnFile;
{
  file for tile
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
  TPSImport_ALFcnFile = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALFcnFile(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALFcnFile_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ALFcnFile
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFcnFile]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFcnFile(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function AlEmptyDirectory( Directory : ansiString; SubDirectory : Boolean; IgnoreFiles : array of AnsiString; const RemoveEmptySubDirectory : Boolean; const FileNameMask : ansiString; const MinFileAge : TdateTime) : Boolean;');
 CL.AddDelphiFunction('Function AlEmptyDirectory1( Directory : ansiString; SubDirectory : Boolean; const RemoveEmptySubDirectory : Boolean; const FileNameMask : ansiString; const MinFileAge : TdateTime) : Boolean;');
 CL.AddDelphiFunction('Function AlCopyDirectory( SrcDirectory, DestDirectory : ansiString; SubDirectory : Boolean; const FileNameMask : ansiString; const FailIfExists : Boolean) : Boolean');
 CL.AddDelphiFunction('Function ALGetModuleName : ansistring');
 CL.AddDelphiFunction('Function ALGetModuleFileNameWithoutExtension : ansistring');
 CL.AddDelphiFunction('Function ALGetModulePath : ansiString');
 CL.AddDelphiFunction('Function AlGetFileSize( const AFileName : ansistring) : int64');
 CL.AddDelphiFunction('Function AlGetFileVersion( const AFileName : ansistring) : ansiString');
 CL.AddDelphiFunction('Function ALGetFileCreationDateTime( const aFileName : Ansistring) : TDateTime');
 CL.AddDelphiFunction('Function ALGetFileLastWriteDateTime( const aFileName : Ansistring) : TDateTime');
 CL.AddDelphiFunction('Function ALGetFileLastAccessDateTime( const aFileName : Ansistring) : TDateTime');
 CL.AddDelphiFunction('Procedure ALSetFileCreationDateTime( const aFileName : Ansistring; const aCreationDateTime : TDateTime)');
 CL.AddDelphiFunction('Function ALIsDirectoryEmpty( const directory : ansiString) : boolean');
 CL.AddDelphiFunction('Function ALFileExists( const Path : ansiString) : boolean');
 CL.AddDelphiFunction('Function ALDirectoryExists( const Directory : Ansistring) : Boolean');
 CL.AddDelphiFunction('Function ALCreateDir( const Dir : Ansistring) : Boolean');
 CL.AddDelphiFunction('Function ALRemoveDir( const Dir : Ansistring) : Boolean');
 CL.AddDelphiFunction('Function ALDeleteFile( const FileName : Ansistring) : Boolean');
 CL.AddDelphiFunction('Function ALRenameFile( const OldName, NewName : ansistring) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function AlEmptyDirectory1_P( Directory : ansiString; SubDirectory : Boolean; const RemoveEmptySubDirectory : Boolean; const FileNameMask : ansiString; const MinFileAge : TdateTime) : Boolean;
Begin Result := ALFcnFile.AlEmptyDirectory(Directory, SubDirectory, RemoveEmptySubDirectory, FileNameMask, MinFileAge); END;

(*----------------------------------------------------------------------------*)
Function AlEmptyDirectory_P( Directory : ansiString; SubDirectory : Boolean; IgnoreFiles : array of AnsiString; const RemoveEmptySubDirectory : Boolean; const FileNameMask : ansiString; const MinFileAge : TdateTime) : Boolean;
Begin Result := ALFcnFile.AlEmptyDirectory(Directory, SubDirectory, IgnoreFiles, RemoveEmptySubDirectory, FileNameMask, MinFileAge); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFcnFile_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AlEmptyDirectory, 'AlEmptyDirectory', cdRegister);
 S.RegisterDelphiFunction(@AlEmptyDirectory1_P, 'AlEmptyDirectory1', cdRegister);
 S.RegisterDelphiFunction(@AlCopyDirectory, 'AlCopyDirectory', cdRegister);
 S.RegisterDelphiFunction(@ALGetModuleName, 'ALGetModuleName', cdRegister);
 S.RegisterDelphiFunction(@ALGetModuleFileNameWithoutExtension, 'ALGetModuleFileNameWithoutExtension', cdRegister);
 S.RegisterDelphiFunction(@ALGetModulePath, 'ALGetModulePath', cdRegister);
 S.RegisterDelphiFunction(@AlGetFileSize, 'AlGetFileSize', cdRegister);
 S.RegisterDelphiFunction(@AlGetFileVersion, 'AlGetFileVersion', cdRegister);
 S.RegisterDelphiFunction(@ALGetFileCreationDateTime, 'ALGetFileCreationDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALGetFileLastWriteDateTime, 'ALGetFileLastWriteDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALGetFileLastAccessDateTime, 'ALGetFileLastAccessDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALSetFileCreationDateTime, 'ALSetFileCreationDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALIsDirectoryEmpty, 'ALIsDirectoryEmpty', cdRegister);
 S.RegisterDelphiFunction(@ALFileExists, 'ALFileExists', cdRegister);
 S.RegisterDelphiFunction(@ALDirectoryExists, 'ALDirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@ALCreateDir, 'ALCreateDir', cdRegister);
 S.RegisterDelphiFunction(@ALRemoveDir, 'ALRemoveDir', cdRegister);
 S.RegisterDelphiFunction(@ALDeleteFile, 'ALDeleteFile', cdRegister);
 S.RegisterDelphiFunction(@ALRenameFile, 'ALRenameFile', cdRegister);
end;



{ TPSImport_ALFcnFile }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnFile.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFcnFile(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnFile.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ALFcnFile(ri);
  RIRegister_ALFcnFile_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
