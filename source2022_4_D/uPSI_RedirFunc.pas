unit uPSI_RedirFunc;
{
   another inno
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
  TPSImport_RedirFunc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTextFileWriterRedir(CL: TPSPascalCompiler);
procedure SIRegister_TTextFileReaderRedir(CL: TPSPascalCompiler);
procedure SIRegister_TFileRedir(CL: TPSPascalCompiler);
procedure SIRegister_RedirFunc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTextFileWriterRedir(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTextFileReaderRedir(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileRedir(CL: TPSRuntimeClassImporter);
procedure RIRegister_RedirFunc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,FileClass
  ,VerInfo
  ,RedirFunc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_RedirFunc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextFileWriterRedir(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTextFileWriter', 'TTextFileWriterRedir') do
  with CL.AddClassN(CL.FindClass('TTextFileWriter'),'TTextFileWriterRedir') do
  begin
    RegisterMethod('Constructor Create( const DisableFsRedir : Boolean; const AFilename : String; ACreateDisposition : TFileCreateDisposition; AAccess : TFileAccess; ASharing : TFileSharing)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextFileReaderRedir(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTextFileReader', 'TTextFileReaderRedir') do
  with CL.AddClassN(CL.FindClass('TTextFileReader'),'TTextFileReaderRedir') do
  begin
    RegisterMethod('Constructor Create( const DisableFsRedir : Boolean; const AFilename : String; ACreateDisposition : TFileCreateDisposition; AAccess : TFileAccess; ASharing : TFileSharing)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileRedir(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFile', 'TFileRedir') do
  with CL.AddClassN(CL.FindClass('TFile'),'TFileRedir') do
  begin
    RegisterMethod('Constructor Create( const DisableFsRedir : Boolean; const AFilename : String; ACreateDisposition : TFileCreateDisposition; AAccess : TFileAccess; ASharing : TFileSharing)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_RedirFunc(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPreviousFsRedirectionState', 'record DidDisable : Boolean; OldValue : ___Pointer; end');

{  type
  TFileVersionNumbers = record
    MS, LS: LongWord;
  end;}
 CL.AddTypeS('TFileVersionNumbers',
    'record' +
    '  MS, LS: LongWord;' +
    'end');

 CL.AddDelphiFunction('Function AreFsRedirectionFunctionsAvailable : Boolean');
 CL.AddDelphiFunction('Function DisableFsRedirectionIf( const Disable : Boolean; var PreviousState : TPreviousFsRedirectionState) : Boolean');
 CL.AddDelphiFunction('Procedure RestoreFsRedirection( const PreviousState : TPreviousFsRedirectionState)');
 CL.AddDelphiFunction('Function CreateDirectoryRedir( const DisableFsRedir : Boolean; const Filename : String) : BOOL');
 CL.AddDelphiFunction('Function CreateProcessRedir( const DisableFsRedir : Boolean; const lpApplicationName : PChar; const lpCommandLine : PChar; const lpProcessAttributes, lpThreadAttributes : PSecurityAttributes; const bInheritHandles : BOOL;'
 +' const dwCreationFlags : DWORD; const lpEnvironment : ___Pointer; const lpCurrentDirectory : PChar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : TProcessInformation) : BOOL');
 CL.AddDelphiFunction('Function CopyFileRedir( const DisableFsRedir : Boolean; const ExistingFilename, NewFilename : String; const FailIfExists : BOOL) : BOOL');
 CL.AddDelphiFunction('Function DeleteFileRedir( const DisableFsRedir : Boolean; const Filename : String) : BOOL');
 CL.AddDelphiFunction('Function DirExistsRedir( const DisableFsRedir : Boolean; const Filename : String) : Boolean');
 CL.AddDelphiFunction('Function FileOrDirExistsRedir( const DisableFsRedir : Boolean; const Filename : String) : Boolean');
 CL.AddDelphiFunction('Function FindFirstFileRedir( const DisableFsRedir : Boolean; const Filename : String; var FindData : TWin32FindData) : THandle');
 CL.AddDelphiFunction('Function GetFileAttributesRedir( const DisableFsRedir : Boolean; const Filename : String) : DWORD');
 CL.AddDelphiFunction('Function GetShortNameRedir( const DisableFsRedir : Boolean; const Filename : String) : String');
 CL.AddDelphiFunction('Function GetVersionNumbersRedir( const DisableFsRedir : Boolean; const Filename : String; var VersionNumbers : TFileVersionNumbers) : Boolean');
 CL.AddDelphiFunction('Function IsDirectoryAndNotReparsePointRedir( const DisableFsRedir : Boolean; const Name : String) : Boolean');
 CL.AddDelphiFunction('Function MoveFileRedir( const DisableFsRedir : Boolean; const ExistingFilename, NewFilename : String) : BOOL');
 CL.AddDelphiFunction('Function MoveFileExRedir( const DisableFsRedir : Boolean; const ExistingFilename, NewFilename : String; const Flags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function NewFileExistsRedir( const DisableFsRedir : Boolean; const Filename : String) : Boolean');
 CL.AddDelphiFunction('Function RemoveDirectoryRedir( const DisableFsRedir : Boolean; const Filename : String) : BOOL');
 CL.AddDelphiFunction('Function SetFileAttributesRedir( const DisableFsRedir : Boolean; const Filename : String; const Attrib : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetNTFSCompressionRedir( const DisableFsRedir : Boolean; const FileOrDir : String; Compress : Boolean) : Boolean');
  SIRegister_TFileRedir(CL);
  SIRegister_TTextFileReaderRedir(CL);
  SIRegister_TTextFileWriterRedir(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextFileWriterRedir(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextFileWriterRedir) do
  begin
    RegisterConstructor(@TTextFileWriterRedir.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextFileReaderRedir(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextFileReaderRedir) do
  begin
    RegisterConstructor(@TTextFileReaderRedir.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileRedir(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileRedir) do
  begin
    RegisterConstructor(@TFileRedir.Create, 'Create');
  end;
  //RIRegister_TFileRedir(CL);
  RIRegister_TTextFileReaderRedir(CL);
  RIRegister_TTextFileWriterRedir(CL);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_RedirFunc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AreFsRedirectionFunctionsAvailable, 'AreFsRedirectionFunctionsAvailable', cdRegister);
 S.RegisterDelphiFunction(@DisableFsRedirectionIf, 'DisableFsRedirectionIf', cdRegister);
 S.RegisterDelphiFunction(@RestoreFsRedirection, 'RestoreFsRedirection', cdRegister);
 S.RegisterDelphiFunction(@CreateDirectoryRedir, 'CreateDirectoryRedir', cdRegister);
 S.RegisterDelphiFunction(@CreateProcessRedir, 'CreateProcessRedir', cdRegister);
 S.RegisterDelphiFunction(@CopyFileRedir, 'CopyFileRedir', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileRedir, 'DeleteFileRedir', cdRegister);
 S.RegisterDelphiFunction(@DirExistsRedir, 'DirExistsRedir', cdRegister);
 S.RegisterDelphiFunction(@FileOrDirExistsRedir, 'FileOrDirExistsRedir', cdRegister);
 S.RegisterDelphiFunction(@FindFirstFileRedir, 'FindFirstFileRedir', cdRegister);
 S.RegisterDelphiFunction(@GetFileAttributesRedir, 'GetFileAttributesRedir', cdRegister);
 S.RegisterDelphiFunction(@GetShortNameRedir, 'GetShortNameRedir', cdRegister);
 S.RegisterDelphiFunction(@GetVersionNumbersRedir, 'GetVersionNumbersRedir', cdRegister);
 S.RegisterDelphiFunction(@IsDirectoryAndNotReparsePointRedir, 'IsDirectoryAndNotReparsePointRedir', cdRegister);
 S.RegisterDelphiFunction(@MoveFileRedir, 'MoveFileRedir', cdRegister);
 S.RegisterDelphiFunction(@MoveFileExRedir, 'MoveFileExRedir', cdRegister);
 S.RegisterDelphiFunction(@NewFileExistsRedir, 'NewFileExistsRedir', cdRegister);
 S.RegisterDelphiFunction(@RemoveDirectoryRedir, 'RemoveDirectoryRedir', cdRegister);
 S.RegisterDelphiFunction(@SetFileAttributesRedir, 'SetFileAttributesRedir', cdRegister);
 S.RegisterDelphiFunction(@SetNTFSCompressionRedir, 'SetNTFSCompressionRedir', cdRegister);
  {RIRegister_TFileRedir(CL);
  RIRegister_TTextFileReaderRedir(CL);
  RIRegister_TTextFileWriterRedir(CL);}
end;

 
 
{ TPSImport_RedirFunc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_RedirFunc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RedirFunc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_RedirFunc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_RedirFunc(ri);
  RIRegister_RedirFunc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
