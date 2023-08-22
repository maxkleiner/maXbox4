unit uPSI_FileUtilsClass;
{
   just one class
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
procedure SIRegister_TFileSearch(CL: TPSPascalCompiler);
procedure SIRegister_FileUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TFileSearch(CL: TPSRuntimeClassImporter);
procedure RIRegister_FileUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   FileUtilsClass
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FileUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileSearch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TFileSearch') do
  with CL.AddClassN(CL.FindClass('TObject'),'TFileSearch') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Search( const Directory, Mask : string);');
    RegisterMethod('Procedure Search1( const Path : string);');
    RegisterProperty('Attributes', 'TAttributeSet', iptrw);
    RegisterProperty('Recurse', 'Boolean', iptrw);
    RegisterProperty('List', 'TStringList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FileUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TFileAttributes', '( faReadOnly, faHidden, faSysFile, faVolumeID'
   +', faDirectory, faArchive, faAnyFile )');
  CL.AddTypeS('TAttributeSet', 'set of TFileAttributes');
  SIRegister_TFileSearch(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFileSearchList_R(Self: TFileSearch; var T: TStringList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearchRecurse_W(Self: TFileSearch; const T: Boolean);
begin Self.Recurse := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearchRecurse_R(Self: TFileSearch; var T: Boolean);
begin T := Self.Recurse; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearchAttributes_W(Self: TFileSearch; const T: TAttributeSet);
begin Self.Attributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileSearchAttributes_R(Self: TFileSearch; var T: TAttributeSet);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
Procedure TFileSearchSearch1_P(Self: TFileSearch;  const Path : string);
Begin Self.Search(Path); END;

(*----------------------------------------------------------------------------*)
Procedure TFileSearchSearch_P(Self: TFileSearch;  const Directory, Mask : string);
Begin Self.Search(Directory, Mask); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileSearch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileSearch) do begin
    RegisterConstructor(@TFileSearch.Create, 'Create');
    RegisterMethod(@TFileSearch.Destroy, 'Free');
     RegisterMethod(@TFileSearchSearch_P, 'Search');
    RegisterMethod(@TFileSearchSearch1_P, 'Search1');
    RegisterPropertyHelper(@TFileSearchAttributes_R,@TFileSearchAttributes_W,'Attributes');
    RegisterPropertyHelper(@TFileSearchRecurse_R,@TFileSearchRecurse_W,'Recurse');
    RegisterPropertyHelper(@TFileSearchList_R,nil,'List');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FileUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFileSearch(CL);
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
  RIRegister_FileUtils(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
