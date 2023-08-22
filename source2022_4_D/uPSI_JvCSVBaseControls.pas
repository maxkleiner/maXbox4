unit uPSI_JvCSVBaseControls;
{
   with jvvclutils
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
  TPSImport_JvCSVBaseControls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvCSVNavigator(CL: TPSPascalCompiler);
procedure SIRegister_TJvCSVCheckBox(CL: TPSPascalCompiler);
procedure SIRegister_TJvCSVComboBox(CL: TPSPascalCompiler);
procedure SIRegister_TJvCSVEdit(CL: TPSPascalCompiler);
procedure SIRegister_TJvCSVBase(CL: TPSPascalCompiler);
procedure SIRegister_JvCSVBaseControls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvCSVNavigator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCSVCheckBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCSVComboBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCSVEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCSVBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvCSVBaseControls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Controls
  ,StdCtrls
  ,Buttons
  ,JvComponentBase
  ,JvComponent
  ,JvCSVBaseControls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCSVBaseControls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCSVNavigator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomControl', 'TJvCSVNavigator') do
  with CL.AddClassN(CL.FindClass('TJvCustomControl'),'TJvCSVNavigator') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure CreateWnd');
    RegisterProperty('CSVDataBase', 'TJvCSVBase', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCSVCheckBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCheckBox', 'TJvCSVCheckBox') do
  with CL.AddClassN(CL.FindClass('TCheckBox'),'TJvCSVCheckBox') do begin
    RegisterProperty('CSVDataBase', 'TJvCSVBase', iptrw);
    RegisterProperty('CSVField', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCSVComboBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComboBox', 'TJvCSVComboBox') do
  with CL.AddClassN(CL.FindClass('TComboBox'),'TJvCSVComboBox') do
  begin
    RegisterProperty('CSVDataBase', 'TJvCSVBase', iptrw);
    RegisterProperty('CSVField', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCSVEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEdit', 'TJvCSVEdit') do
  with CL.AddClassN(CL.FindClass('TEdit'),'TJvCSVEdit') do
  begin
    RegisterProperty('CSVDataBase', 'TJvCSVBase', iptrw);
    RegisterProperty('CSVField', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCSVBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvCSVBase') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvCSVBase') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure DataBaseCreate( const AFile : string; FieldNames : TStrings; AChangeExt : Boolean; AAskIfExists : Boolean)');
    RegisterMethod('Procedure DataBaseOpen( const AFile : string)');
    RegisterMethod('Procedure DataBaseClose');
    RegisterMethod('Procedure DataBaseRestructure( const AFile : string; FieldNames : TStrings)');
    RegisterMethod('Procedure RecordNew');
    RegisterMethod('Procedure RecordGet( NameValues : TStrings; UseNames : Boolean)');
    RegisterMethod('Procedure RecordSet( NameValues : TStrings; UseNames : Boolean)');
    RegisterMethod('Procedure RecordDelete');
    RegisterMethod('Function RecordNext : Boolean');
    RegisterMethod('Function RecordPrevious : Boolean');
    RegisterMethod('Function RecordFirst : Boolean');
    RegisterMethod('Function RecordLast : Boolean');
    RegisterMethod('Procedure RecordPost');
    RegisterMethod('Function RecordFind( const AText : string) : Boolean');
    RegisterMethod('Procedure Display');
    RegisterProperty('CSVFileName', 'string', iptrw);
    RegisterProperty('CSVFieldNames', 'TStrings', iptrw);
    RegisterProperty('OnCursorChanged', 'TCursorChangedEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCSVBaseControls(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCursorChangedEvent', 'Procedure ( Sender : TObject; NameValues '
   +': TStrings; FieldCount : Integer)');
  SIRegister_TJvCSVBase(CL);
  SIRegister_TJvCSVEdit(CL);
  SIRegister_TJvCSVComboBox(CL);
  SIRegister_TJvCSVCheckBox(CL);
  SIRegister_TJvCSVNavigator(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvCSVNavigatorCSVDataBase_W(Self: TJvCSVNavigator; const T: TJvCSVBase);
begin Self.CSVDataBase := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVNavigatorCSVDataBase_R(Self: TJvCSVNavigator; var T: TJvCSVBase);
begin T := Self.CSVDataBase; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVCheckBoxCSVField_W(Self: TJvCSVCheckBox; const T: string);
begin Self.CSVField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVCheckBoxCSVField_R(Self: TJvCSVCheckBox; var T: string);
begin T := Self.CSVField; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVCheckBoxCSVDataBase_W(Self: TJvCSVCheckBox; const T: TJvCSVBase);
begin Self.CSVDataBase := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVCheckBoxCSVDataBase_R(Self: TJvCSVCheckBox; var T: TJvCSVBase);
begin T := Self.CSVDataBase; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVComboBoxCSVField_W(Self: TJvCSVComboBox; const T: string);
begin Self.CSVField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVComboBoxCSVField_R(Self: TJvCSVComboBox; var T: string);
begin T := Self.CSVField; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVComboBoxCSVDataBase_W(Self: TJvCSVComboBox; const T: TJvCSVBase);
begin Self.CSVDataBase := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVComboBoxCSVDataBase_R(Self: TJvCSVComboBox; var T: TJvCSVBase);
begin T := Self.CSVDataBase; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVEditCSVField_W(Self: TJvCSVEdit; const T: string);
begin Self.CSVField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVEditCSVField_R(Self: TJvCSVEdit; var T: string);
begin T := Self.CSVField; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVEditCSVDataBase_W(Self: TJvCSVEdit; const T: TJvCSVBase);
begin Self.CSVDataBase := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVEditCSVDataBase_R(Self: TJvCSVEdit; var T: TJvCSVBase);
begin T := Self.CSVDataBase; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVBaseOnCursorChanged_W(Self: TJvCSVBase; const T: TCursorChangedEvent);
begin Self.OnCursorChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVBaseOnCursorChanged_R(Self: TJvCSVBase; var T: TCursorChangedEvent);
begin T := Self.OnCursorChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVBaseCSVFieldNames_W(Self: TJvCSVBase; const T: TStrings);
begin Self.CSVFieldNames := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVBaseCSVFieldNames_R(Self: TJvCSVBase; var T: TStrings);
begin T := Self.CSVFieldNames; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVBaseCSVFileName_W(Self: TJvCSVBase; const T: string);
begin Self.CSVFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCSVBaseCSVFileName_R(Self: TJvCSVBase; var T: string);
begin T := Self.CSVFileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCSVNavigator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCSVNavigator) do
  begin
    RegisterConstructor(@TJvCSVNavigator.Create, 'Create');
    RegisterMethod(@TJvCSVNavigator.CreateWnd, 'CreateWnd');
    RegisterPropertyHelper(@TJvCSVNavigatorCSVDataBase_R,@TJvCSVNavigatorCSVDataBase_W,'CSVDataBase');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCSVCheckBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCSVCheckBox) do
  begin
    RegisterPropertyHelper(@TJvCSVCheckBoxCSVDataBase_R,@TJvCSVCheckBoxCSVDataBase_W,'CSVDataBase');
    RegisterPropertyHelper(@TJvCSVCheckBoxCSVField_R,@TJvCSVCheckBoxCSVField_W,'CSVField');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCSVComboBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCSVComboBox) do
  begin
    RegisterPropertyHelper(@TJvCSVComboBoxCSVDataBase_R,@TJvCSVComboBoxCSVDataBase_W,'CSVDataBase');
    RegisterPropertyHelper(@TJvCSVComboBoxCSVField_R,@TJvCSVComboBoxCSVField_W,'CSVField');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCSVEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCSVEdit) do
  begin
    RegisterPropertyHelper(@TJvCSVEditCSVDataBase_R,@TJvCSVEditCSVDataBase_W,'CSVDataBase');
    RegisterPropertyHelper(@TJvCSVEditCSVField_R,@TJvCSVEditCSVField_W,'CSVField');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCSVBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCSVBase) do begin
    RegisterConstructor(@TJvCSVBase.Create, 'Create');
    RegisterMethod(@TJvCSVBase.Destroy, 'Free');
    RegisterMethod(@TJvCSVBase.DataBaseCreate, 'DataBaseCreate');
    RegisterMethod(@TJvCSVBase.DataBaseOpen, 'DataBaseOpen');
    RegisterMethod(@TJvCSVBase.DataBaseClose, 'DataBaseClose');
    RegisterMethod(@TJvCSVBase.DataBaseRestructure, 'DataBaseRestructure');
    RegisterMethod(@TJvCSVBase.RecordNew, 'RecordNew');
    RegisterMethod(@TJvCSVBase.RecordGet, 'RecordGet');
    RegisterMethod(@TJvCSVBase.RecordSet, 'RecordSet');
    RegisterMethod(@TJvCSVBase.RecordDelete, 'RecordDelete');
    RegisterMethod(@TJvCSVBase.RecordNext, 'RecordNext');
    RegisterMethod(@TJvCSVBase.RecordPrevious, 'RecordPrevious');
    RegisterMethod(@TJvCSVBase.RecordFirst, 'RecordFirst');
    RegisterMethod(@TJvCSVBase.RecordLast, 'RecordLast');
    RegisterMethod(@TJvCSVBase.RecordPost, 'RecordPost');
    RegisterMethod(@TJvCSVBase.RecordFind, 'RecordFind');
    RegisterMethod(@TJvCSVBase.Display, 'Display');
    RegisterPropertyHelper(@TJvCSVBaseCSVFileName_R,@TJvCSVBaseCSVFileName_W,'CSVFileName');
    RegisterPropertyHelper(@TJvCSVBaseCSVFieldNames_R,@TJvCSVBaseCSVFieldNames_W,'CSVFieldNames');
    RegisterPropertyHelper(@TJvCSVBaseOnCursorChanged_R,@TJvCSVBaseOnCursorChanged_W,'OnCursorChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCSVBaseControls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvCSVBase(CL);
  RIRegister_TJvCSVEdit(CL);
  RIRegister_TJvCSVComboBox(CL);
  RIRegister_TJvCSVCheckBox(CL);
  RIRegister_TJvCSVNavigator(CL);
end;

 
 
{ TPSImport_JvCSVBaseControls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCSVBaseControls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCSVBaseControls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCSVBaseControls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvCSVBaseControls(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
