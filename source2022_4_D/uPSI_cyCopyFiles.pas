unit uPSI_cyCopyFiles;
{
   copy that floppy  nr 1002
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
  TPSImport_cyCopyFiles = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyCopyFiles(CL: TPSPascalCompiler);
procedure SIRegister_TDestinationOptions(CL: TPSPascalCompiler);
procedure SIRegister_cyCopyFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyCopyFiles_Routines(S: TPSExec);
procedure RIRegister_TcyCopyFiles(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDestinationOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyCopyFiles(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StrUtils
  ,Windows
  ,ComCtrls
  ,cySearchFiles
  ,cyCopyFiles
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyCopyFiles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyCopyFiles(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TcyCustomSearchFiles', 'TcyCopyFiles') do
  with CL.AddClassN(CL.FindClass('TcyCustomSearchFiles'),'TcyCopyFiles') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
         RegisterMethod('Procedure Free');
     RegisterMethod('Function Execute : boolean');
    RegisterMethod('Procedure DefaultCopyFile');
    RegisterProperty('CancelCurrentFile', 'Boolean', iptrw);
    RegisterProperty('FileSource', 'String', iptr);
    RegisterProperty('FileDestination', 'String', iptr);
    RegisterProperty('CurrentFileProcess', 'TCopyFileResult', iptr);
    RegisterProperty('CopyFilesCount', 'Integer', iptr);
    RegisterProperty('CopyFailsCount', 'Integer', iptr);
    RegisterProperty('DestinationOptions', 'TDestinationOptions', iptrw);
    RegisterProperty('DestinationPath', 'String', iptrw);
    RegisterProperty('BeforeCopyFile', 'TNotifyEvent', iptrw);
    RegisterProperty('CustomCopyFile', 'TProcCustomCopyFileEvent', iptrw);
    RegisterProperty('AfterCopyFile', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCustomSetFileDestination', 'TProcOnCustomSetFileDestination', iptrw);
    RegisterProperty('OnCopyFileFailed', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCopyFileProgress', 'TProcOnCopyFileProgressEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDestinationOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TDestinationOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TDestinationOptions') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ResetAttributes', 'boolean', iptrw);
    RegisterProperty('IfFileExists', 'TCopyFileExists', iptrw);
    RegisterProperty('IfFileNotExists', 'TCopyFileNotExists', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyCopyFiles(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCopyFileResult', '( cfCreate, cfOverwrite, cfNoNeed, cfForceDirectoryError, cfCopyError )');
  CL.AddTypeS('TCopyFileExists', '( feDoNothing, feCopy, feCopyIfModified, feCopyIfMoreRecent )');
  CL.AddTypeS('TCopyFileNotExists', '( fnDoNothing, fnCopy, fnCopyForceDir )');

  CL.AddTypeS('_LARGE_INTEGER',' record QuadPart: LONGLONG; end;');
   {   LowPart: DWORD;
      HighPart: Longint);
    1: (
      QuadPart: LONGLONG);
  end;}
  //{$EXTERNALSYM _LARGE_INTEGER}
  //{$NODEFINE TLargeInteger}
  //TLargeInteger = Int64;
   CL.AddTypeS('TcyFileAttributeMode','(faYes, faNo, faBoth)');

  CL.AddTypeS('LARGE_INTEGER','_LARGE_INTEGER');
   SIRegister_TDestinationOptions(CL);
  CL.AddTypeS('TProcCustomCopyFileEvent', 'Procedure ( Sender : TObject; var CopyFileResult : TCopyFileResult)');
  CL.AddTypeS('TProcOnCopyFileProgressEvent', 'Procedure ( Sender : TObject; FileBytes, TransferedBytes : int64; PercentDone : Int64)');
  CL.AddTypeS('TProcOnCustomSetFileDestination', 'Procedure ( Sender : TObject; var FileName : String)');
  SIRegister_TcyCopyFiles(CL);
 CL.AddDelphiFunction('Function cyCopyFile( FromFile, ToFile : String; FileExists : TCopyFileExists; FileNotExists : TCopyFileNotExists; ResetAttr : boolean) : TCopyFileResult');
 CL.AddDelphiFunction('Function cyCopyFileEx( FromFile, ToFile : String; FileExists : TCopyFileExists; FileNotExists : TCopyFileNotExists; ResetAttr : boolean; aProgressBar : TProgressBar) : TCopyFileResult');
 CL.AddDelphiFunction('Function cyCopyFilesEx( SourcePath, DestinationPath, IncludeFilters, ExcludeFilters : String; ArchiveFiles, ReadOnlyFiles, HiddenFiles, SystemFiles : TcyFileAttributeMode; FileExists : TCopyFileExists;'
                     +' FileNotExists : TCopyFileNotExists; SubFolders, ResetAttributes : Boolean) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesOnCopyFileProgress_W(Self: TcyCopyFiles; const T: TProcOnCopyFileProgressEvent);
begin Self.OnCopyFileProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesOnCopyFileProgress_R(Self: TcyCopyFiles; var T: TProcOnCopyFileProgressEvent);
begin T := Self.OnCopyFileProgress; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesOnCopyFileFailed_W(Self: TcyCopyFiles; const T: TNotifyEvent);
begin Self.OnCopyFileFailed := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesOnCopyFileFailed_R(Self: TcyCopyFiles; var T: TNotifyEvent);
begin T := Self.OnCopyFileFailed; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesOnCustomSetFileDestination_W(Self: TcyCopyFiles; const T: TProcOnCustomSetFileDestination);
begin Self.OnCustomSetFileDestination := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesOnCustomSetFileDestination_R(Self: TcyCopyFiles; var T: TProcOnCustomSetFileDestination);
begin T := Self.OnCustomSetFileDestination; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesAfterCopyFile_W(Self: TcyCopyFiles; const T: TNotifyEvent);
begin Self.AfterCopyFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesAfterCopyFile_R(Self: TcyCopyFiles; var T: TNotifyEvent);
begin T := Self.AfterCopyFile; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesCustomCopyFile_W(Self: TcyCopyFiles; const T: TProcCustomCopyFileEvent);
begin Self.CustomCopyFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesCustomCopyFile_R(Self: TcyCopyFiles; var T: TProcCustomCopyFileEvent);
begin T := Self.CustomCopyFile; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesBeforeCopyFile_W(Self: TcyCopyFiles; const T: TNotifyEvent);
begin Self.BeforeCopyFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesBeforeCopyFile_R(Self: TcyCopyFiles; var T: TNotifyEvent);
begin T := Self.BeforeCopyFile; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesDestinationPath_W(Self: TcyCopyFiles; const T: String);
begin Self.DestinationPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesDestinationPath_R(Self: TcyCopyFiles; var T: String);
begin T := Self.DestinationPath; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesDestinationOptions_W(Self: TcyCopyFiles; const T: TDestinationOptions);
begin Self.DestinationOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesDestinationOptions_R(Self: TcyCopyFiles; var T: TDestinationOptions);
begin T := Self.DestinationOptions; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesCopyFailsCount_R(Self: TcyCopyFiles; var T: Integer);
begin T := Self.CopyFailsCount; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesCopyFilesCount_R(Self: TcyCopyFiles; var T: Integer);
begin T := Self.CopyFilesCount; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesCurrentFileProcess_R(Self: TcyCopyFiles; var T: TCopyFileResult);
begin T := Self.CurrentFileProcess; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesFileDestination_R(Self: TcyCopyFiles; var T: String);
begin T := Self.FileDestination; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesFileSource_R(Self: TcyCopyFiles; var T: String);
begin T := Self.FileSource; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesCancelCurrentFile_W(Self: TcyCopyFiles; const T: Boolean);
begin Self.CancelCurrentFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCopyFilesCancelCurrentFile_R(Self: TcyCopyFiles; var T: Boolean);
begin T := Self.CancelCurrentFile; end;

(*----------------------------------------------------------------------------*)
procedure TDestinationOptionsIfFileNotExists_W(Self: TDestinationOptions; const T: TCopyFileNotExists);
begin Self.IfFileNotExists := T; end;

(*----------------------------------------------------------------------------*)
procedure TDestinationOptionsIfFileNotExists_R(Self: TDestinationOptions; var T: TCopyFileNotExists);
begin T := Self.IfFileNotExists; end;

(*----------------------------------------------------------------------------*)
procedure TDestinationOptionsIfFileExists_W(Self: TDestinationOptions; const T: TCopyFileExists);
begin Self.IfFileExists := T; end;

(*----------------------------------------------------------------------------*)
procedure TDestinationOptionsIfFileExists_R(Self: TDestinationOptions; var T: TCopyFileExists);
begin T := Self.IfFileExists; end;

(*----------------------------------------------------------------------------*)
procedure TDestinationOptionsResetAttributes_W(Self: TDestinationOptions; const T: boolean);
begin Self.ResetAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TDestinationOptionsResetAttributes_R(Self: TDestinationOptions; var T: boolean);
begin T := Self.ResetAttributes; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyCopyFiles_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@cyCopyFile, 'cyCopyFile', cdRegister);
 S.RegisterDelphiFunction(@cyCopyFileEx, 'cyCopyFileEx', cdRegister);
 S.RegisterDelphiFunction(@cyCopyFilesEx, 'cyCopyFilesEx', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyCopyFiles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyCopyFiles) do begin
    RegisterConstructor(@TcyCopyFiles.Create, 'Create');
         RegisterMethod(@TcyCopyFiles.Destroy, 'Free');
     RegisterMethod(@TcyCopyFiles.Execute, 'Execute');
    RegisterMethod(@TcyCopyFiles.DefaultCopyFile, 'DefaultCopyFile');
    RegisterPropertyHelper(@TcyCopyFilesCancelCurrentFile_R,@TcyCopyFilesCancelCurrentFile_W,'CancelCurrentFile');
    RegisterPropertyHelper(@TcyCopyFilesFileSource_R,nil,'FileSource');
    RegisterPropertyHelper(@TcyCopyFilesFileDestination_R,nil,'FileDestination');
    RegisterPropertyHelper(@TcyCopyFilesCurrentFileProcess_R,nil,'CurrentFileProcess');
    RegisterPropertyHelper(@TcyCopyFilesCopyFilesCount_R,nil,'CopyFilesCount');
    RegisterPropertyHelper(@TcyCopyFilesCopyFailsCount_R,nil,'CopyFailsCount');
    RegisterPropertyHelper(@TcyCopyFilesDestinationOptions_R,@TcyCopyFilesDestinationOptions_W,'DestinationOptions');
    RegisterPropertyHelper(@TcyCopyFilesDestinationPath_R,@TcyCopyFilesDestinationPath_W,'DestinationPath');
    RegisterPropertyHelper(@TcyCopyFilesBeforeCopyFile_R,@TcyCopyFilesBeforeCopyFile_W,'BeforeCopyFile');
    RegisterPropertyHelper(@TcyCopyFilesCustomCopyFile_R,@TcyCopyFilesCustomCopyFile_W,'CustomCopyFile');
    RegisterPropertyHelper(@TcyCopyFilesAfterCopyFile_R,@TcyCopyFilesAfterCopyFile_W,'AfterCopyFile');
    RegisterPropertyHelper(@TcyCopyFilesOnCustomSetFileDestination_R,@TcyCopyFilesOnCustomSetFileDestination_W,'OnCustomSetFileDestination');
    RegisterPropertyHelper(@TcyCopyFilesOnCopyFileFailed_R,@TcyCopyFilesOnCopyFileFailed_W,'OnCopyFileFailed');
    RegisterPropertyHelper(@TcyCopyFilesOnCopyFileProgress_R,@TcyCopyFilesOnCopyFileProgress_W,'OnCopyFileProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDestinationOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDestinationOptions) do
  begin
    RegisterVirtualConstructor(@TDestinationOptions.Create, 'Create');
    RegisterPropertyHelper(@TDestinationOptionsResetAttributes_R,@TDestinationOptionsResetAttributes_W,'ResetAttributes');
    RegisterPropertyHelper(@TDestinationOptionsIfFileExists_R,@TDestinationOptionsIfFileExists_W,'IfFileExists');
    RegisterPropertyHelper(@TDestinationOptionsIfFileNotExists_R,@TDestinationOptionsIfFileNotExists_W,'IfFileNotExists');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyCopyFiles(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDestinationOptions(CL);
  RIRegister_TcyCopyFiles(CL);
end;

 
 
{ TPSImport_cyCopyFiles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyCopyFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyCopyFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyCopyFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyCopyFiles(ri);
  RIRegister_cyCopyFiles_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
