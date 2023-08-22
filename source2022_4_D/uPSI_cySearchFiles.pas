unit uPSI_cySearchFiles;
{
    in search with copy files
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
  TPSImport_cySearchFiles = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcySearchFiles(CL: TPSPascalCompiler);
procedure SIRegister_TcyCustomSearchFiles(CL: TPSPascalCompiler);
procedure SIRegister_TSearchRecInstance(CL: TPSPascalCompiler);
procedure SIRegister_TcyFileAttributes(CL: TPSPascalCompiler);
procedure SIRegister_cySearchFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cySearchFiles_Routines(S: TPSExec);
procedure RIRegister_TcySearchFiles(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcyCustomSearchFiles(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSearchRecInstance(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcyFileAttributes(CL: TPSRuntimeClassImporter);
procedure RIRegister_cySearchFiles(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Forms
  ,StrUtils
  ,cySearchFiles
  ,kcMapViewer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cySearchFiles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcySearchFiles(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TcyCustomSearchFiles', 'TcySearchFiles') do
  with CL.AddClassN(CL.FindClass('TcyCustomSearchFiles'),'TcySearchFiles') do begin
    Registerpublishedproperties;
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
   RegisterPublishedProperties;
     RegisterProperty('FileAttributes', 'TcyFileAttributes', iptrw);
     RegisterProperty('FromPath', 'string', iptrw);
     RegisterProperty('MaskInclude', 'tstrings', iptrw);
     RegisterProperty('MaskExclude', 'tstrings', iptrw);
     RegisterProperty('Options', 'TOptions', iptrw);
     RegisterProperty('SubDirectories', 'boolean', iptrw);
     RegisterProperty('OnAbort', 'TNotifyEvent', iptrw);
     RegisterProperty('OnPause', 'TNotifyEvent', iptrw);
     RegisterProperty('OnResume', 'TNotifyEvent', iptrw);
     RegisterProperty('OnExitDirectory', 'TNotifyEvent', iptrw);
     RegisterProperty('OnTerminate', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyCustomSearchFiles(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyCustomSearchFiles') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyCustomSearchFiles') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
      RegisterMethod('Function Abort : boolean');
    RegisterMethod('Function Pause : boolean');
    RegisterMethod('Function Resume : boolean');
    RegisterMethod('Function Execute : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSearchRecInstance(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSearchRecInstance') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSearchRecInstance') do
  begin
    RegisterProperty('SuspendedSearchRec', 'TSearchRecInstance', iptr);
    RegisterProperty('SearchRec', 'TSearchRec', iptr);
    RegisterProperty('Path', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyFileAttributes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TcyFileAttributes') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TcyFileAttributes') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Archive', 'TcyFileAttributeMode', iptrw);
    RegisterProperty('ReadOnly', 'TcyFileAttributeMode', iptrw);
    RegisterProperty('Hidden', 'TcyFileAttributeMode', iptrw);
    RegisterProperty('System', 'TcyFileAttributeMode', iptrw);
    RegisterProperty('Temporary', 'TcyFileAttributeMode', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cySearchFiles(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TcyFileAttributeMode', '( faYes, faNo, faBoth )');
  SIRegister_TcyFileAttributes(CL);
  SIRegister_TSearchRecInstance(CL);
  CL.AddTypeS('TOption', '( soOnlyDirs, soIgnoreAttributes, soIgnoreMaskInclude, soIgnoreMaskExclude )');
  CL.AddTypeS('TOptions', 'set of TOption');
  CL.AddTypeS('TSearchState', '( ssIdle, ssPaused, ssSearch, ssPausing, ssResuming, ssAborting )');
  CL.AddTypeS('TProcOnValidateFileEvent', 'Procedure ( Sender : TObject; ValidM'
   +'askInclude, ValidMaskExclude, ValidAttributes : boolean; var Accept : boolean)');
  CL.AddTypeS('TProcOnValidateDirectoryEvent', 'Procedure ( Sender : TObject; Directory : String; var Accept : boolean)');
  SIRegister_TcyCustomSearchFiles(CL);
  SIRegister_TcySearchFiles(CL);
 CL.AddDelphiFunction('Function FileNameRespondToMask( aFileName : String; aMask : String) : Boolean');
 CL.AddDelphiFunction('Function IscyFolder( aSRec : TSearchrec) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSearchRecInstancePath_R(Self: TSearchRecInstance; var T: String);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TSearchRecInstanceSearchRec_R(Self: TSearchRecInstance; var T: TSearchRec);
begin T := Self.SearchRec; end;

(*----------------------------------------------------------------------------*)
procedure TSearchRecInstanceSuspendedSearchRec_R(Self: TSearchRecInstance; var T: TSearchRecInstance);
begin T := Self.SuspendedSearchRec; end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesTemporary_W(Self: TcyFileAttributes; const T: TcyFileAttributeMode);
begin //Self.Temporary := T;
end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesTemporary_R(Self: TcyFileAttributes; var T: TcyFileAttributeMode);
begin //T := Self.Temporary;
end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesSystem_W(Self: TcyFileAttributes; const T: TcyFileAttributeMode);
begin Self.System := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesSystem_R(Self: TcyFileAttributes; var T: TcyFileAttributeMode);
begin T := Self.System; end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesHidden_W(Self: TcyFileAttributes; const T: TcyFileAttributeMode);
begin Self.Hidden := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesHidden_R(Self: TcyFileAttributes; var T: TcyFileAttributeMode);
begin T := Self.Hidden; end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesReadOnly_W(Self: TcyFileAttributes; const T: TcyFileAttributeMode);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesReadOnly_R(Self: TcyFileAttributes; var T: TcyFileAttributeMode);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesArchive_W(Self: TcyFileAttributes; const T: TcyFileAttributeMode);
begin Self.Archive := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyFileAttributesArchive_R(Self: TcyFileAttributes; var T: TcyFileAttributeMode);
begin T := Self.Archive; end;


procedure Tcysearchfileactivesr_W(Self: TcySearchFiles; const T: TSearchRecInstance);
begin //Self.ActiveSearchRec:= T;
end;

(*----------------------------------------------------------------------------*)
procedure Tcysearchfileactivesr_R(Self: TcySearchFiles; var T: TSearchRecInstance);
begin T := Self.ActiveSearchRec; end;


{procedure TcyFilesearchfileactivesr_W(Self: TcySearchFiles; const T: TSearchRecInstance);
begin //Self.ActiveSearchRec:= T;
end;}

(*----------------------------------------------------------------------------*)
procedure TcysearchfileAbort_R(Self: TcySearchFiles; var T: boolean);
begin T := Self.Aborted; end;

procedure TcysearchfileCurrentFileName_R(Self: TcySearchFiles; var T: string);
begin T := Self.CurrentFileName; end;

procedure TcysearchfileCurrentDirectory_R(Self: TcySearchFiles; var T: string);
begin T := Self.CurrentDirectory; end;

procedure TcysearchfileMatchedDirectories_R(Self: TcySearchFiles; var T: integer);
begin T := Self.MatchedDirectories; end;
procedure TcysearchfileMatchedFiles_R(Self: TcySearchFiles; var T: integer);
begin T := Self.MatchedFiles; end;
procedure TcysearchfileSearchState_R(Self: TcySearchFiles; var T: TSearchState);
begin T := Self.SearchState; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cySearchFiles_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FileNameRespondToMask, 'FileNameRespondToMask', cdRegister);
 S.RegisterDelphiFunction(@IsFolder, 'IscyFolder', cdRegister);
 S.RegisterDelphiFunction(@IsValidPNG, 'IsValidPNG', cdRegister);
 S.RegisterDelphiFunction(@IsValidJPEG, 'IsValidJPEG', cdRegister);
 //  function IsValidPNG(stream: TStream): Boolean; from kcmapviewer
 // function IsValidJPEG(stream: TStream): Boolean;
end;

 (*----------------------------------------------------------------------------*)
procedure RIRegister_TcySearchFiles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcySearchFiles) do begin
    RegisterPropertyHelper(@TcySearchFileActiveSR_R,@TcyFileAttributesReadOnly_W,'ActiveSearchRec');
    RegisterPropertyHelper(@TcySearchFileAbort_R,NIL,'Aborted');
    RegisterPropertyHelper(@TcysearchfileCurrentFileName_R,NIL,'CurrentFileName');
    RegisterPropertyHelper(@TcysearchfileCurrentDirectory_R,NIL,'CurrentDirectory');
    RegisterPropertyHelper(@TcysearchfileMatchedDirectories_R,NIL,'MatchedDirectories');
  RegisterPropertyHelper(@TcysearchfileMatchedFiles_R,NIL,'MatchedFiles');
  RegisterPropertyHelper(@TcysearchfileSearchState_R,NIL,'SearchState');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyCustomSearchFiles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyCustomSearchFiles) do begin
    RegisterConstructor(@TcyCustomSearchFiles.Create, 'Create');
       RegisterMethod(@TcyCustomSearchFiles.Destroy, 'Free');
    RegisterMethod(@TcyCustomSearchFiles.Abort, 'Abort');
    RegisterMethod(@TcyCustomSearchFiles.Pause, 'Pause');
    RegisterMethod(@TcyCustomSearchFiles.Resume, 'Resume');
    RegisterVirtualMethod(@TcyCustomSearchFiles.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSearchRecInstance(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSearchRecInstance) do
  begin
    RegisterPropertyHelper(@TSearchRecInstanceSuspendedSearchRec_R,nil,'SuspendedSearchRec');
    RegisterPropertyHelper(@TSearchRecInstanceSearchRec_R,nil,'SearchRec');
    RegisterPropertyHelper(@TSearchRecInstancePath_R,nil,'Path');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyFileAttributes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyFileAttributes) do
  begin
    RegisterVirtualConstructor(@TcyFileAttributes.Create, 'Create');
    RegisterPropertyHelper(@TcyFileAttributesArchive_R,@TcyFileAttributesArchive_W,'Archive');
    RegisterPropertyHelper(@TcyFileAttributesReadOnly_R,@TcyFileAttributesReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TcyFileAttributesHidden_R,@TcyFileAttributesHidden_W,'Hidden');
    RegisterPropertyHelper(@TcyFileAttributesSystem_R,@TcyFileAttributesSystem_W,'System');
    RegisterPropertyHelper(@TcyFileAttributesTemporary_R,@TcyFileAttributesTemporary_W,'Temporary');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cySearchFiles(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyFileAttributes(CL);
  RIRegister_TSearchRecInstance(CL);
  RIRegister_TcyCustomSearchFiles(CL);
  RIRegister_TcySearchFiles(CL);
end;

 
 
{ TPSImport_cySearchFiles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cySearchFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cySearchFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cySearchFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cySearchFiles(ri);
  RIRegister_cySearchFiles_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
