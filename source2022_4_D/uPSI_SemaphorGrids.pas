unit uPSI_SemaphorGrids;
{
a grid for signaling

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
  TPSImport_SemaphorGrids = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSemaphorGrid(CL: TPSPascalCompiler);
procedure SIRegister_SemaphorGrids(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SemaphorGrids_Routines(S: TPSExec);
procedure RIRegister_TSemaphorGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_SemaphorGrids(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   FileUtil
 { ,LResources
  ,LCLProc
  ,LCLIntf
  ,LCLType    }
  ,Forms
  ,Controls
  ,Graphics
  ,Dialogs
  ,Grids
  ,SemaphorGrids
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SemaphorGrids]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSemaphorGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringGrid', 'TSemaphorGrid') do
  with CL.AddClassN(CL.FindClass('TStringGrid'),'TSemaphorGrid') do
  begin
    RegisterMethod('Procedure LoadFromFileG( FileName : string; autoadjust : boolean)');
    RegisterMethod('Procedure SaveToFileG( FileName : String; addMarker : boolean)');
    RegisterMethod('Procedure SaveToString( var StringName : String; addMarker : boolean)');
    RegisterMethod('Procedure AssignG( SG : TSemaphorGrid; autoadjust : boolean)');
    RegisterMethod('Procedure AssignToG( SG : TSemaphorGrid; autoadjust : boolean)');
    RegisterMethod('Procedure AutoWidth');
    RegisterMethod('Procedure AutoHeight');
    RegisterMethod('Procedure AutoFit');
    RegisterMethod('Procedure ExportToExcel( FileName : string; SelfExt : boolean)');
    RegisterMethod('Procedure DeleteColumn( j : integer)');
    RegisterMethod('Procedure DeleteRow( i : integer)');
    RegisterMethod('Procedure SortFromColumn( j : integer; TS : TTypeSort; SD : TDirection; autoadjust : boolean)');
    RegisterMethod('Procedure HideCol( j : integer)');
    RegisterMethod('Procedure ShowCol( j : integer)');
    RegisterMethod('Procedure ShowAllCols');
    RegisterMethod('Function Duplicate( var SG : TSemaphorGrid) : boolean');
    RegisterMethod('Procedure ClearColRow( isColumn : boolean; i : integer)');
    RegisterMethod('Procedure Clear( OnlyValue : boolean)');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('CHSEP', 'Char', iptrw);
    RegisterProperty('Semaphor', 'boolean', iptrw);
    RegisterProperty('StringRed', 'string', iptrw);
    RegisterProperty('StringYellow', 'string', iptrw);
    RegisterProperty('StringGreen', 'string', iptrw);
    RegisterProperty('SemaphorShape', 'TSemaphorShape', iptrw);
    RegisterProperty('SemaphorCaseSensitive', 'boolean', iptrw);
    RegisterProperty('SemaphorOnlyFloat', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SemaphorGrids(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SemaphorMarker','String').SetString( 'S_M_0_1');
  CL.AddTypeS('TSheetType', '( stLandScape, stPortrait )');
  CL.AddTypeS('TSemaphorShape', '( ssTopBar, ssBottomBar, ssLeftBar, ssRigthBar'
   +', ssTopLeftSquare, ssTopRigthSquare, ssBottomLeftSquare, ssBottomRigth, ssDisk )');
  CL.AddTypeS('TDirection', '( sdDescending, sdAscending )');
  CL.AddTypeS('TTypeSort', '( tsAlphabetic, tsDate, tsNumeric, tsAutomatic )');
  SIRegister_TSemaphorGrid(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSemaphorGridSemaphorOnlyFloat_W(Self: TSemaphorGrid; const T: boolean);
begin Self.SemaphorOnlyFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridSemaphorOnlyFloat_R(Self: TSemaphorGrid; var T: boolean);
begin T := Self.SemaphorOnlyFloat; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridSemaphorCaseSensitive_W(Self: TSemaphorGrid; const T: boolean);
begin Self.SemaphorCaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridSemaphorCaseSensitive_R(Self: TSemaphorGrid; var T: boolean);
begin T := Self.SemaphorCaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridSemaphorShape_W(Self: TSemaphorGrid; const T: TSemaphorShape);
begin Self.SemaphorShape := T; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridSemaphorShape_R(Self: TSemaphorGrid; var T: TSemaphorShape);
begin T := Self.SemaphorShape; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridStringGreen_W(Self: TSemaphorGrid; const T: string);
begin Self.StringGreen := T; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridStringGreen_R(Self: TSemaphorGrid; var T: string);
begin T := Self.StringGreen; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridStringYellow_W(Self: TSemaphorGrid; const T: string);
begin Self.StringYellow := T; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridStringYellow_R(Self: TSemaphorGrid; var T: string);
begin T := Self.StringYellow; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridStringRed_W(Self: TSemaphorGrid; const T: string);
begin Self.StringRed := T; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridStringRed_R(Self: TSemaphorGrid; var T: string);
begin T := Self.StringRed; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridSemaphor_W(Self: TSemaphorGrid; const T: boolean);
begin Self.Semaphor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridSemaphor_R(Self: TSemaphorGrid; var T: boolean);
begin T := Self.Semaphor; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridCHSEP_W(Self: TSemaphorGrid; const T: Char);
begin Self.CHSEP := T; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridCHSEP_R(Self: TSemaphorGrid; var T: Char);
begin T := Self.CHSEP; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridAlignment_W(Self: TSemaphorGrid; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TSemaphorGridAlignment_R(Self: TSemaphorGrid; var T: TAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SemaphorGrids_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSemaphorGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSemaphorGrid) do begin
    RegisterMethod(@TSemaphorGrid.LoadFromFileG, 'LoadFromFileG');
    RegisterMethod(@TSemaphorGrid.SaveToFileG, 'SaveToFileG');
    RegisterMethod(@TSemaphorGrid.SaveToString, 'SaveToString');
    RegisterMethod(@TSemaphorGrid.AssignG, 'AssignG');
    RegisterMethod(@TSemaphorGrid.AssignToG, 'AssignToG');
    RegisterMethod(@TSemaphorGrid.AutoWidth, 'AutoWidth');
    RegisterMethod(@TSemaphorGrid.AutoHeight, 'AutoHeight');
    RegisterMethod(@TSemaphorGrid.AutoFit, 'AutoFit');
    RegisterMethod(@TSemaphorGrid.ExportToExcel, 'ExportToExcel');
    RegisterMethod(@TSemaphorGrid.DeleteColumn, 'DeleteColumn');
    RegisterMethod(@TSemaphorGrid.DeleteRow, 'DeleteRow');
    RegisterMethod(@TSemaphorGrid.SortFromColumn, 'SortFromColumn');
    RegisterMethod(@TSemaphorGrid.HideCol, 'HideCol');
    RegisterMethod(@TSemaphorGrid.ShowCol, 'ShowCol');
    RegisterMethod(@TSemaphorGrid.ShowAllCols, 'ShowAllCols');
    RegisterMethod(@TSemaphorGrid.Duplicate, 'Duplicate');
    RegisterMethod(@TSemaphorGrid.ClearColRow, 'ClearColRow');
    RegisterMethod(@TSemaphorGrid.Clear, 'Clear');
    RegisterConstructor(@TSemaphorGrid.Create, 'Create');
    RegisterMethod(@TSemaphorGrid.Destroy, 'Free');
    RegisterPropertyHelper(@TSemaphorGridAlignment_R,@TSemaphorGridAlignment_W,'Alignment');
    RegisterPropertyHelper(@TSemaphorGridCHSEP_R,@TSemaphorGridCHSEP_W,'CHSEP');
    RegisterPropertyHelper(@TSemaphorGridSemaphor_R,@TSemaphorGridSemaphor_W,'Semaphor');
    RegisterPropertyHelper(@TSemaphorGridStringRed_R,@TSemaphorGridStringRed_W,'StringRed');
    RegisterPropertyHelper(@TSemaphorGridStringYellow_R,@TSemaphorGridStringYellow_W,'StringYellow');
    RegisterPropertyHelper(@TSemaphorGridStringGreen_R,@TSemaphorGridStringGreen_W,'StringGreen');
    RegisterPropertyHelper(@TSemaphorGridSemaphorShape_R,@TSemaphorGridSemaphorShape_W,'SemaphorShape');
    RegisterPropertyHelper(@TSemaphorGridSemaphorCaseSensitive_R,@TSemaphorGridSemaphorCaseSensitive_W,'SemaphorCaseSensitive');
    RegisterPropertyHelper(@TSemaphorGridSemaphorOnlyFloat_R,@TSemaphorGridSemaphorOnlyFloat_W,'SemaphorOnlyFloat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SemaphorGrids(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSemaphorGrid(CL);
end;

 
 
{ TPSImport_SemaphorGrids }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SemaphorGrids.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SemaphorGrids(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SemaphorGrids.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SemaphorGrids(ri);
  RIRegister_SemaphorGrids_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
