unit uPSI_JvPatchFile;
{
  of the newones
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
  TPSImport_JvPatchFile = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvPatchFile(CL: TPSPascalCompiler);
procedure SIRegister_JvPatchFile(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvPatchFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvPatchFile(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  JvTypes
  ,JvComponentBase
  ,JvPatchFile
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvPatchFile]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvPatchFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvPatchFile') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvPatchFile') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Patch( const Password : string) : Boolean');
    RegisterMethod('Function IsPatched( const FileName : string) : Boolean');
    RegisterMethod('Function IsPatchable( const FileName : string) : Boolean');
    RegisterProperty('StartFile', 'TFileName', iptrw);
    RegisterProperty('EndFile', 'TFileName', iptrw);
    RegisterProperty('ChangeInFile', 'Boolean', iptrw);
    RegisterProperty('Differences', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvPatchFile(CL: TPSPascalCompiler);
begin
  SIRegister_TJvPatchFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvPatchFileDifferences_W(Self: TJvPatchFile; const T: TStrings);
begin Self.Differences := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPatchFileDifferences_R(Self: TJvPatchFile; var T: TStrings);
begin T := Self.Differences; end;

(*----------------------------------------------------------------------------*)
procedure TJvPatchFileChangeInFile_W(Self: TJvPatchFile; const T: Boolean);
begin Self.ChangeInFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPatchFileChangeInFile_R(Self: TJvPatchFile; var T: Boolean);
begin T := Self.ChangeInFile; end;

(*----------------------------------------------------------------------------*)
procedure TJvPatchFileEndFile_W(Self: TJvPatchFile; const T: TFileName);
begin Self.EndFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPatchFileEndFile_R(Self: TJvPatchFile; var T: TFileName);
begin T := Self.EndFile; end;

(*----------------------------------------------------------------------------*)
procedure TJvPatchFileStartFile_W(Self: TJvPatchFile; const T: TFileName);
begin Self.StartFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPatchFileStartFile_R(Self: TJvPatchFile; var T: TFileName);
begin T := Self.StartFile; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvPatchFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvPatchFile) do begin
    RegisterConstructor(@TJvPatchFile.Create, 'Create');
     RegisterMethod(@TJvPatchFile.Destroy, 'Free');
    RegisterMethod(@TJvPatchFile.Patch, 'Patch');
    RegisterMethod(@TJvPatchFile.IsPatched, 'IsPatched');
    RegisterMethod(@TJvPatchFile.IsPatchable, 'IsPatchable');
    RegisterPropertyHelper(@TJvPatchFileStartFile_R,@TJvPatchFileStartFile_W,'StartFile');
    RegisterPropertyHelper(@TJvPatchFileEndFile_R,@TJvPatchFileEndFile_W,'EndFile');
    RegisterPropertyHelper(@TJvPatchFileChangeInFile_R,@TJvPatchFileChangeInFile_W,'ChangeInFile');
    RegisterPropertyHelper(@TJvPatchFileDifferences_R,@TJvPatchFileDifferences_W,'Differences');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvPatchFile(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvPatchFile(CL);
end;

 
 
{ TPSImport_JvPatchFile }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPatchFile.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvPatchFile(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPatchFile.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvPatchFile(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
