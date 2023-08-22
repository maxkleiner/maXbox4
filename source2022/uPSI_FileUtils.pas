unit uPSI_FileUtils;
{
 from OpenGL or LDAP  by Michael Vinther imported by max
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
  TPSImport_FileUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_FileUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_FileUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // Windows
  //,ShellAPI
  //,MemUtils
  //,Controls
  //,Messages
  //,Registry
  //,Forms
  //Shlobj
  FileUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FileUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_FileUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function InitTempPath : string');
 CL.AddDelphiFunction('Procedure WriteLog( const FileName, LogLine : string)');
 CL.AddDelphiFunction('Function ExecuteFile( const FileName : string; const Params : string; const DefaultDir : string; ShowCmd : Integer) : THandle');
 CL.AddDelphiFunction('Function RemoveFileExt( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileExtNoDot( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileExtNoDotUpper( const FileName : string) : string');
 CL.AddDelphiFunction('Function ForceBackslash( const PathName : string) : string');
 CL.AddDelphiFunction('Function RemoveBackslash( const PathName : string) : string');
 CL.AddDelphiFunction('Function SetFileTimeStamp( const FileName : string; TimeStamp : Integer) : Boolean');
 CL.AddDelphiFunction('Function GetFileSize( const FileName : string) : Int64');
 CL.AddDelphiFunction('Function SearchRecFileSize64( const SearchRec : TSearchRec) : Int64');
 CL.AddDelphiFunction('Function FileContains( const FileName : string; Text : string; CaseSensitive : Boolean; ExceptionOnError : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure GetDirList( const Search : string; List : TStrings; Recursive : Boolean)');
 CL.AddDelphiFunction('Function DeleteFileEx( FileName : string; Flags : FILEOP_FLAGS) : Boolean');
 CL.AddDelphiFunction('Function MoveFile( Source, Dest : string; Flags : FILEOP_FLAGS) : Boolean');
 CL.AddDelphiFunction('Function CopyFile( Source, Dest : string; CanOverwrite : Boolean) : Boolean');
 CL.AddDelphiFunction('Function CopyFileEx( Source, Dest : string; Flags : FILEOP_FLAGS) : Boolean');
 CL.AddDelphiFunction('Function MakeValidFileName( const Str : string) : string');
 CL.AddDelphiFunction('Procedure ShowFileProperties( const FileName : string)');
 CL.AddDelphiFunction('Procedure ShowSearchDialog( const Directory : string)');
 CL.AddDelphiFunction('Function GetParameterFileName : string');
 CL.AddDelphiFunction('Function LoadFileAsString( const FileName : string) : string');
 CL.AddDelphiFunction('Procedure CreateFileFromString( const FileName, Data : string)');
 //CL.AddDelphiFunction('Function GetDroppedFile( const Msg : TWMDropFiles; Index : Integer) : string');
 CL.AddDelphiFunction('Procedure RegisterFileFormat( Extension, AppID : string; Description : string; Executable : string; IconIndex : Integer)');
 CL.AddDelphiFunction('Function IsFormatRegistered( Extension, AppID : string) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_FileUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitTempPath, 'InitTempPath', cdRegister);
 S.RegisterDelphiFunction(@WriteLog, 'WriteLog', cdRegister);
 S.RegisterDelphiFunction(@ExecuteFile, 'ExecuteFile', cdRegister);
 S.RegisterDelphiFunction(@RemoveFileExt, 'RemoveFileExt', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExtNoDot, 'ExtractFileExtNoDot', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExtNoDotUpper, 'ExtractFileExtNoDotUpper', cdRegister);
 S.RegisterDelphiFunction(@ForceBackslash, 'ForceBackslash', cdRegister);
 S.RegisterDelphiFunction(@RemoveBackslash, 'RemoveBackslash', cdRegister);
 S.RegisterDelphiFunction(@SetFileTimeStamp, 'SetFileTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@GetFileSize, 'GetFileSize', cdRegister);
 S.RegisterDelphiFunction(@SearchRecFileSize64, 'SearchRecFileSize64', cdRegister);
 S.RegisterDelphiFunction(@FileContains, 'FileContains', cdRegister);
 S.RegisterDelphiFunction(@GetDirList, 'GetDirList', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileEx, 'DeleteFileEx', cdRegister);
 S.RegisterDelphiFunction(@MoveFile, 'MoveFile', cdRegister);
 S.RegisterDelphiFunction(@CopyFile, 'CopyFile', cdRegister);
 S.RegisterDelphiFunction(@CopyFileEx, 'CopyFileEx', cdRegister);
 S.RegisterDelphiFunction(@MakeValidFileName, 'MakeValidFileName', cdRegister);
 S.RegisterDelphiFunction(@ShowFileProperties, 'ShowFileProperties', cdRegister);
 S.RegisterDelphiFunction(@ShowSearchDialog, 'ShowSearchDialog', cdRegister);
 S.RegisterDelphiFunction(@GetParameterFileName, 'GetParameterFileName', cdRegister);
 S.RegisterDelphiFunction(@LoadFileAsString, 'LoadFileAsString', cdRegister);
 S.RegisterDelphiFunction(@CreateFileFromString, 'CreateFileFromString', cdRegister);
 S.RegisterDelphiFunction(@GetDroppedFile, 'GetDroppedFile', cdRegister);
 S.RegisterDelphiFunction(@RegisterFileFormat, 'RegisterFileFormat', cdRegister);
 S.RegisterDelphiFunction(@IsFormatRegistered, 'IsFormatRegistered', cdRegister);
end;

 
 
{ TPSImport_FileUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FileUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_FileUtils(ri);
  RIRegister_FileUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
