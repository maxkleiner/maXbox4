unit uPSI_cyIniForm;
{
   to configure things    - change attribute
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
  TPSImport_cyIniForm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyIniForm(CL: TPSPascalCompiler);
procedure SIRegister_TcyTempForm(CL: TPSPascalCompiler);
procedure SIRegister_cyIniForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyIniForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcyTempForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyIniForm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,Forms
  ,Inifiles
  ,Registry
  ,SHFolder
  ,cyIniForm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyIniForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyIniForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyIniForm') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyIniForm') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Function GetFile : String');
    RegisterMethod('Function GetRootKey : HKey');
    RegisterMethod('Function LoadDefinitions : Boolean');
    RegisterMethod('Function SaveDefinitions : Boolean');
    RegisterMethod('Procedure DeleteDefinitions');
    RegisterProperty('Attributes', 'TAttributes2', iptrw);
    RegisterProperty('AutoLoad', 'Boolean', iptrw);
    RegisterProperty('AutoSave', 'Boolean', iptrw);
    RegisterProperty('IniCustomfile', 'String', iptrw);
    RegisterProperty('IniCustomSection', 'String', iptrw);
    RegisterProperty('IniDirectory', 'TIniDirectory', iptrw);
    RegisterProperty('IniSubDirs', 'String', iptrw);
    RegisterProperty('Mode', 'TMode', iptrw);
    RegisterProperty('RegRoot', 'TRegRoot', iptrw);
    RegisterProperty('RegCustomKey', 'String', iptrw);
    RegisterProperty('StoreVersion', 'String', iptrw);
    RegisterProperty('OnCustomLoadFromFile', 'TProcOnReadFile', iptrw);
    RegisterProperty('OnCustomSaveToFile', 'TProcOnWriteFile', iptrw);
    RegisterProperty('OnCustomLoadFromRegistry', 'TProcOnReadRegistry', iptrw);
    RegisterProperty('OnCustomSaveToRegistry', 'TProcOnWriteRegistry', iptrw);
    RegisterProperty('OnNotLoadFromFile', 'TProcOnReadFile', iptrw);
    RegisterProperty('OnNotLoadFromRegistry', 'TProcOnReadRegistry', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyTempForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomForm', 'TcyTempForm') do
  with CL.AddClassN(CL.FindClass('TCustomForm'),'TcyTempForm') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyIniForm(CL: TPSPascalCompiler);
begin
  SIRegister_TcyTempForm(CL);
  CL.AddTypeS('RAttributes', 'record Top : Integer; Left : Integer; Width : Int'
   +'eger; Height : Integer; Visible : Boolean; State : Integer; end');
  CL.AddTypeS('TProcOnReadFile', 'Procedure ( Sender : TObject; IniFile : TInifile; FileVersion : String)');
  CL.AddTypeS('TProcOnReadRegistry', 'Procedure ( Sender : TObject; Registry : '
   +'TRegistry; RegistryVersion : String)');
  CL.AddTypeS('TProcOnWriteFile', 'Procedure ( Sender : TObject; IniFile : TInifile)');
  CL.AddTypeS('TProcOnWriteRegistry', 'Procedure ( Sender : TObject; Registry : TRegistry)');
  CL.AddTypeS('TAttribute2', '( atPosition, atSize, atVisible, atMinimized, atMaximized )');
  CL.AddTypeS('TAttributes2', 'set of TAttribute2');
  CL.AddTypeS('TMode', '( mFile, mRegistry, mBoth )');
  CL.AddTypeS('TIniDirectory', '( idProgramLocation, idCommonAppData, idLocalAppData )');
  CL.AddTypeS('TRegRoot','(rrKEY_CLASSES_ROOT, rrKEY_CURRENT_USER, rrKEY_LOCAL_MACHINE, rrKEY_USERS, rrKEY_CURRENT_CONFIG )');
  SIRegister_TcyIniForm(CL);
 //CL.AddConstantN('cNormal','LongInt').SetInt( 0);
 //CL.AddConstantN('cMaximized','LongInt').SetInt( 1);
 //CL.AddConstantN('cMinimized','LongInt').SetInt( 2);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnNotLoadFromRegistry_W(Self: TcyIniForm; const T: TProcOnReadRegistry);
begin Self.OnNotLoadFromRegistry := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnNotLoadFromRegistry_R(Self: TcyIniForm; var T: TProcOnReadRegistry);
begin T := Self.OnNotLoadFromRegistry; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnNotLoadFromFile_W(Self: TcyIniForm; const T: TProcOnReadFile);
begin Self.OnNotLoadFromFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnNotLoadFromFile_R(Self: TcyIniForm; var T: TProcOnReadFile);
begin T := Self.OnNotLoadFromFile; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnCustomSaveToRegistry_W(Self: TcyIniForm; const T: TProcOnWriteRegistry);
begin Self.OnCustomSaveToRegistry := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnCustomSaveToRegistry_R(Self: TcyIniForm; var T: TProcOnWriteRegistry);
begin T := Self.OnCustomSaveToRegistry; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnCustomLoadFromRegistry_W(Self: TcyIniForm; const T: TProcOnReadRegistry);
begin Self.OnCustomLoadFromRegistry := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnCustomLoadFromRegistry_R(Self: TcyIniForm; var T: TProcOnReadRegistry);
begin T := Self.OnCustomLoadFromRegistry; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnCustomSaveToFile_W(Self: TcyIniForm; const T: TProcOnWriteFile);
begin Self.OnCustomSaveToFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnCustomSaveToFile_R(Self: TcyIniForm; var T: TProcOnWriteFile);
begin T := Self.OnCustomSaveToFile; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnCustomLoadFromFile_W(Self: TcyIniForm; const T: TProcOnReadFile);
begin Self.OnCustomLoadFromFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormOnCustomLoadFromFile_R(Self: TcyIniForm; var T: TProcOnReadFile);
begin T := Self.OnCustomLoadFromFile; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormStoreVersion_W(Self: TcyIniForm; const T: String);
begin Self.StoreVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormStoreVersion_R(Self: TcyIniForm; var T: String);
begin T := Self.StoreVersion; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormRegCustomKey_W(Self: TcyIniForm; const T: String);
begin Self.RegCustomKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormRegCustomKey_R(Self: TcyIniForm; var T: String);
begin T := Self.RegCustomKey; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormRegRoot_W(Self: TcyIniForm; const T: TRegRoot);
begin Self.RegRoot := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormRegRoot_R(Self: TcyIniForm; var T: TRegRoot);
begin T := Self.RegRoot; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormMode_W(Self: TcyIniForm; const T: TMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormMode_R(Self: TcyIniForm; var T: TMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormIniSubDirs_W(Self: TcyIniForm; const T: String);
begin Self.IniSubDirs := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormIniSubDirs_R(Self: TcyIniForm; var T: String);
begin T := Self.IniSubDirs; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormIniDirectory_W(Self: TcyIniForm; const T: TIniDirectory);
begin Self.IniDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormIniDirectory_R(Self: TcyIniForm; var T: TIniDirectory);
begin T := Self.IniDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormIniCustomSection_W(Self: TcyIniForm; const T: String);
begin Self.IniCustomSection := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormIniCustomSection_R(Self: TcyIniForm; var T: String);
begin T := Self.IniCustomSection; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormIniCustomfile_W(Self: TcyIniForm; const T: String);
begin Self.IniCustomfile := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormIniCustomfile_R(Self: TcyIniForm; var T: String);
begin T := Self.IniCustomfile; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormAutoSave_W(Self: TcyIniForm; const T: Boolean);
begin Self.AutoSave := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormAutoSave_R(Self: TcyIniForm; var T: Boolean);
begin T := Self.AutoSave; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormAutoLoad_W(Self: TcyIniForm; const T: Boolean);
begin Self.AutoLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormAutoLoad_R(Self: TcyIniForm; var T: Boolean);
begin T := Self.AutoLoad; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormAttributes_W(Self: TcyIniForm; const T: TAttributes);
begin Self.Attributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyIniFormAttributes_R(Self: TcyIniForm; var T: TAttributes);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyIniForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyIniForm) do begin
    RegisterConstructor(@TcyIniForm.Create, 'Create');
    RegisterMethod(@TcyIniForm.GetFile, 'GetFile');
    RegisterMethod(@TcyIniForm.GetRootKey, 'GetRootKey');
    RegisterMethod(@TcyIniForm.LoadDefinitions, 'LoadDefinitions');
    RegisterMethod(@TcyIniForm.SaveDefinitions, 'SaveDefinitions');
    RegisterMethod(@TcyIniForm.DeleteDefinitions, 'DeleteDefinitions');
    RegisterPropertyHelper(@TcyIniFormAttributes_R,@TcyIniFormAttributes_W,'Attributes');
    RegisterPropertyHelper(@TcyIniFormAutoLoad_R,@TcyIniFormAutoLoad_W,'AutoLoad');
    RegisterPropertyHelper(@TcyIniFormAutoSave_R,@TcyIniFormAutoSave_W,'AutoSave');
    RegisterPropertyHelper(@TcyIniFormIniCustomfile_R,@TcyIniFormIniCustomfile_W,'IniCustomfile');
    RegisterPropertyHelper(@TcyIniFormIniCustomSection_R,@TcyIniFormIniCustomSection_W,'IniCustomSection');
    RegisterPropertyHelper(@TcyIniFormIniDirectory_R,@TcyIniFormIniDirectory_W,'IniDirectory');
    RegisterPropertyHelper(@TcyIniFormIniSubDirs_R,@TcyIniFormIniSubDirs_W,'IniSubDirs');
    RegisterPropertyHelper(@TcyIniFormMode_R,@TcyIniFormMode_W,'Mode');
    RegisterPropertyHelper(@TcyIniFormRegRoot_R,@TcyIniFormRegRoot_W,'RegRoot');
    RegisterPropertyHelper(@TcyIniFormRegCustomKey_R,@TcyIniFormRegCustomKey_W,'RegCustomKey');
    RegisterPropertyHelper(@TcyIniFormStoreVersion_R,@TcyIniFormStoreVersion_W,'StoreVersion');
    RegisterPropertyHelper(@TcyIniFormOnCustomLoadFromFile_R,@TcyIniFormOnCustomLoadFromFile_W,'OnCustomLoadFromFile');
    RegisterPropertyHelper(@TcyIniFormOnCustomSaveToFile_R,@TcyIniFormOnCustomSaveToFile_W,'OnCustomSaveToFile');
    RegisterPropertyHelper(@TcyIniFormOnCustomLoadFromRegistry_R,@TcyIniFormOnCustomLoadFromRegistry_W,'OnCustomLoadFromRegistry');
    RegisterPropertyHelper(@TcyIniFormOnCustomSaveToRegistry_R,@TcyIniFormOnCustomSaveToRegistry_W,'OnCustomSaveToRegistry');
    RegisterPropertyHelper(@TcyIniFormOnNotLoadFromFile_R,@TcyIniFormOnNotLoadFromFile_W,'OnNotLoadFromFile');
    RegisterPropertyHelper(@TcyIniFormOnNotLoadFromRegistry_R,@TcyIniFormOnNotLoadFromRegistry_W,'OnNotLoadFromRegistry');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyTempForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyTempForm) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyIniForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyTempForm(CL);
  RIRegister_TcyIniForm(CL);
end;

 
 
{ TPSImport_cyIniForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyIniForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyIniForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyIniForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyIniForm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
