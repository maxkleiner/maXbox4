unit uPSI_JvSHFileOperation;
{
    SHShell
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
  TPSImport_JvSHFileOperation = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSHFileOperation(CL: TPSPascalCompiler);
procedure SIRegister_JvSHFileOperation(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSHFileOperation(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSHFileOperation(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,ShellAPI
  ,Controls
  ,JvBaseDlg
  ,JvWin32
  ,JvSHFileOperation
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSHFileOperation]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSHFileOperation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialog', 'TJvSHFileOperation') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialog'),'TJvSHFileOperation') do begin
    RegisterMethod('Function Execute : Boolean');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('LastErrorMsg', 'string', iptr);
    RegisterProperty('SourceFiles', 'TStrings', iptrw);
    RegisterProperty('DestFiles', 'TStrings', iptrw);
    RegisterProperty('Operation', 'TJvSHFileOpType', iptrw);
    RegisterProperty('Options', 'TJvSHFileOptions', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('OnFileMapping', 'TJvShFileMappingEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSHFileOperation(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvShFileMappingEvent', 'Procedure ( Sender : TObject; const Old'
   +'FileName, NewFileName : string)');
  CL.AddTypeS('TJvSHFileOpType', '( foCopy, foDelete, foMove, foRename )');
  CL.AddTypeS('TJvSHFileOption', '( fofAllowUndo, fofConfirmMouse, fofFilesOnly'
   +', fofMultiDestFiles, fofNoConfirmation, fofNoConfirmMkDir, fofRenameOnColl'
   +'ision, fofSilent, fofSimpleProgress, fofWantMappingHandle, fofNoErrorUI, f'
   +'ofNoCopySecurityAttributes, fofNoRecursion, fofNoConnectedElements, fofNoRecurseParse, fofWantNukeWarning )');
  CL.AddTypeS('TJvSHFileOptions', 'set of TJvSHFileOption');
  SIRegister_TJvSHFileOperation(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationOnFileMapping_W(Self: TJvSHFileOperation; const T: TJvShFileMappingEvent);
begin Self.OnFileMapping := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationOnFileMapping_R(Self: TJvSHFileOperation; var T: TJvShFileMappingEvent);
begin T := Self.OnFileMapping; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationTitle_W(Self: TJvSHFileOperation; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationTitle_R(Self: TJvSHFileOperation; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationOptions_W(Self: TJvSHFileOperation; const T: TJvSHFileOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationOptions_R(Self: TJvSHFileOperation; var T: TJvSHFileOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationOperation_W(Self: TJvSHFileOperation; const T: TJvSHFileOpType);
begin Self.Operation := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationOperation_R(Self: TJvSHFileOperation; var T: TJvSHFileOpType);
begin T := Self.Operation; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationDestFiles_W(Self: TJvSHFileOperation; const T: TStrings);
begin Self.DestFiles := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationDestFiles_R(Self: TJvSHFileOperation; var T: TStrings);
begin T := Self.DestFiles; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationSourceFiles_W(Self: TJvSHFileOperation; const T: TStrings);
begin Self.SourceFiles := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationSourceFiles_R(Self: TJvSHFileOperation; var T: TStrings);
begin T := Self.SourceFiles; end;

(*----------------------------------------------------------------------------*)
procedure TJvSHFileOperationLastErrorMsg_R(Self: TJvSHFileOperation; var T: string);
begin T := Self.LastErrorMsg; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSHFileOperation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSHFileOperation) do begin
    RegisterMethod(@TJvSHFileOperation.Execute, 'Execute');
    RegisterMethod(@TJvSHFileOperation.Destroy, 'Free');
     RegisterConstructor(@TJvSHFileOperation.Create, 'Create');
    RegisterPropertyHelper(@TJvSHFileOperationLastErrorMsg_R,nil,'LastErrorMsg');
    RegisterPropertyHelper(@TJvSHFileOperationSourceFiles_R,@TJvSHFileOperationSourceFiles_W,'SourceFiles');
    RegisterPropertyHelper(@TJvSHFileOperationDestFiles_R,@TJvSHFileOperationDestFiles_W,'DestFiles');
    RegisterPropertyHelper(@TJvSHFileOperationOperation_R,@TJvSHFileOperationOperation_W,'Operation');
    RegisterPropertyHelper(@TJvSHFileOperationOptions_R,@TJvSHFileOperationOptions_W,'Options');
    RegisterPropertyHelper(@TJvSHFileOperationTitle_R,@TJvSHFileOperationTitle_W,'Title');
    RegisterPropertyHelper(@TJvSHFileOperationOnFileMapping_R,@TJvSHFileOperationOnFileMapping_W,'OnFileMapping');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSHFileOperation(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvSHFileOperation(CL);
end;

 
 
{ TPSImport_JvSHFileOperation }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSHFileOperation.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSHFileOperation(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSHFileOperation.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSHFileOperation(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
