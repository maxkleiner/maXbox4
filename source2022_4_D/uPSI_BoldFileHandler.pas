unit uPSI_BoldFileHandler;
{
   oo file handler
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
  TPSImport_BoldFileHandler = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBoldDiskFileHandler(CL: TPSPascalCompiler);
procedure SIRegister_TBoldFileHandler(CL: TPSPascalCompiler);
procedure SIRegister_BoldFileHandler(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BoldFileHandler_Routines(S: TPSExec);
procedure RIRegister_TBoldDiskFileHandler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBoldFileHandler(CL: TPSRuntimeClassImporter);
procedure RIRegister_BoldFileHandler(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // BoldLogHandler
  BoldDefs
  //,BoldContainers
  ,BoldFileHandler
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldFileHandler]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldDiskFileHandler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBoldFileHandler', 'TBoldDiskFileHandler') do
  with CL.AddClassN(CL.FindClass('TBoldFileHandler'),'TBoldDiskFileHandler') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldFileHandler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBoldFileHandler') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldFileHandler') do begin
    RegisterMethod('Constructor Create( const FileName : string; ModuleType : TBoldModuleType; ShowFileInGuiIfPossible : Boolean; OnInitializeFileContents : TBoldInitializeFileContents)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AddString( const s : string)');
    RegisterMethod('Procedure AddStrings( s : TStrings)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Dedent');
    RegisterMethod('Procedure EndBlock( const AddNewLine : boolean)');
    RegisterMethod('Procedure FlushFile');
    RegisterMethod('Procedure Format( const Fmt : string; Args : array of const)');
    RegisterMethod('Procedure FormatLn( const Fmt : string; Args : array of const)');
    RegisterMethod('Procedure Indent');
    RegisterMethod('Procedure ModifyContents( const NewContents : string; Replace : Boolean)');
    RegisterMethod('Procedure NewLine');
    RegisterMethod('Procedure StartBlock');
    RegisterMethod('Procedure InitializeStringList');
    RegisterMethod('Function TextFoundInFile( const S : string) : Boolean');
    RegisterMethod('Procedure WriteLn( const Str : string)');
    RegisterProperty('Content', 'string integer', iptr);
    RegisterProperty('Count', 'integer', iptr);
    RegisterProperty('FileFilter', 'String', iptrw);
    RegisterProperty('Filename', 'string', iptrw);
    RegisterProperty('IsEmpty', 'boolean', iptr);
    RegisterProperty('LastWasNewLine', 'Boolean', iptr);
    RegisterProperty('ModuleType', 'TBoldModuleType', iptr);
    RegisterProperty('OnInitializeFileContents', 'TBoldInitializeFileContents', iptr);
    RegisterProperty('SetFileName', 'string', iptr);
    RegisterProperty('StringListModified', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldFileHandler(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldFileHandler');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldDiskFileHandler');
  //CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldObjectArray');
   //TBoldObjectArray = class;
  //CL.AddTypeS('TBoldFileHandlerClass', 'class of TBoldFileHandler');
  CL.AddTypeS('TBoldInitializeFileContents', 'Procedure ( StringList : TStringList)');
  SIRegister_TBoldFileHandler(CL);
  SIRegister_TBoldDiskFileHandler(CL);
 CL.AddDelphiFunction('Procedure BoldCloseAllFilehandlers');
 CL.AddDelphiFunction('Procedure BoldRemoveUnchangedFilesFromEditor');
 CL.AddDelphiFunction('Function BoldFileHandlerList : TBoldObjectArray');
 //CL.AddDelphiFunction('Function BoldFileHandlerForFile( path, FileName : String; ModuleType : TBoldModuleType; ShowInEditor : Boolean; OnInitializeFileContents : TBoldInitializeFileContents) : TBoldFileHandler');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerStringListModified_R(Self: TBoldFileHandler; var T: Boolean);
begin T := Self.StringListModified; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerSetFileName_R(Self: TBoldFileHandler; var T: string);
begin T := Self.SetFileName; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerOnInitializeFileContents_R(Self: TBoldFileHandler; var T: TBoldInitializeFileContents);
begin T := Self.OnInitializeFileContents; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerModuleType_R(Self: TBoldFileHandler; var T: TBoldModuleType);
begin T := Self.ModuleType; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerLastWasNewLine_R(Self: TBoldFileHandler; var T: Boolean);
begin T := Self.LastWasNewLine; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerIsEmpty_R(Self: TBoldFileHandler; var T: boolean);
begin T := Self.IsEmpty; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerFilename_W(Self: TBoldFileHandler; const T: string);
begin Self.Filename := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerFilename_R(Self: TBoldFileHandler; var T: string);
begin T := Self.Filename; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerFileFilter_W(Self: TBoldFileHandler; const T: String);
begin Self.FileFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerFileFilter_R(Self: TBoldFileHandler; var T: String);
begin T := Self.FileFilter; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerCount_R(Self: TBoldFileHandler; var T: integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TBoldFileHandlerContent_R(Self: TBoldFileHandler; var T: string; const t1: integer);
begin T := Self.Content[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldFileHandler_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BoldCloseAllFilehandlers, 'BoldCloseAllFilehandlers', cdRegister);
 S.RegisterDelphiFunction(@BoldRemoveUnchangedFilesFromEditor, 'BoldRemoveUnchangedFilesFromEditor', cdRegister);
 S.RegisterDelphiFunction(@BoldFileHandlerList, 'BoldFileHandlerList', cdRegister);
 S.RegisterDelphiFunction(@BoldFileHandlerForFile, 'BoldFileHandlerForFile', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldDiskFileHandler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldDiskFileHandler) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldFileHandler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldFileHandler) do begin
    RegisterVirtualConstructor(@TBoldFileHandler.Create, 'Create');
    RegisterMethod(@TBoldFileHandler.Destroy, 'Free');
    RegisterMethod(@TBoldFileHandler.AddString, 'AddString');
    RegisterMethod(@TBoldFileHandler.AddStrings, 'AddStrings');
    RegisterMethod(@TBoldFileHandler.Clear, 'Clear');
    RegisterMethod(@TBoldFileHandler.Dedent, 'Dedent');
    RegisterMethod(@TBoldFileHandler.EndBlock, 'EndBlock');
    RegisterMethod(@TBoldFileHandler.FlushFile, 'FlushFile');
    RegisterMethod(@TBoldFileHandler.Format, 'Format');
    RegisterMethod(@TBoldFileHandler.FormatLn, 'FormatLn');
    RegisterMethod(@TBoldFileHandler.Indent, 'Indent');
    RegisterMethod(@TBoldFileHandler.ModifyContents, 'ModifyContents');
    RegisterMethod(@TBoldFileHandler.NewLine, 'NewLine');
    RegisterMethod(@TBoldFileHandler.StartBlock, 'StartBlock');
    RegisterMethod(@TBoldFileHandler.InitializeStringList, 'InitializeStringList');
    RegisterMethod(@TBoldFileHandler.TextFoundInFile, 'TextFoundInFile');
    RegisterMethod(@TBoldFileHandler.WriteLn, 'WriteLn');
    RegisterPropertyHelper(@TBoldFileHandlerContent_R,nil,'Content');
    RegisterPropertyHelper(@TBoldFileHandlerCount_R,nil,'Count');
    RegisterPropertyHelper(@TBoldFileHandlerFileFilter_R,@TBoldFileHandlerFileFilter_W,'FileFilter');
    RegisterPropertyHelper(@TBoldFileHandlerFilename_R,@TBoldFileHandlerFilename_W,'Filename');
    RegisterPropertyHelper(@TBoldFileHandlerIsEmpty_R,nil,'IsEmpty');
    RegisterPropertyHelper(@TBoldFileHandlerLastWasNewLine_R,nil,'LastWasNewLine');
    RegisterPropertyHelper(@TBoldFileHandlerModuleType_R,nil,'ModuleType');
    RegisterPropertyHelper(@TBoldFileHandlerOnInitializeFileContents_R,nil,'OnInitializeFileContents');
    RegisterPropertyHelper(@TBoldFileHandlerSetFileName_R,nil,'SetFileName');
    RegisterPropertyHelper(@TBoldFileHandlerStringListModified_R,nil,'StringListModified');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldFileHandler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldFileHandler) do
  with CL.Add(TBoldDiskFileHandler) do
  RIRegister_TBoldFileHandler(CL);
  RIRegister_TBoldDiskFileHandler(CL);
end;

 
 
{ TPSImport_BoldFileHandler }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldFileHandler.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldFileHandler(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldFileHandler.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BoldFileHandler(ri);
  RIRegister_BoldFileHandler_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
