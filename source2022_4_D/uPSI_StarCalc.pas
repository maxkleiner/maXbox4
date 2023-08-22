unit uPSI_StarCalc;
{
   test to staroffice  export
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
  TPSImport_StarCalc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStarCalcExport(CL: TPSPascalCompiler);
procedure SIRegister_StarCalc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StarCalc_Routines(S: TPSExec);
procedure RIRegister_TStarCalcExport(CL: TPSRuntimeClassImporter);
procedure RIRegister_StarCalc(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DB
  ,Variants
  ,StarCalc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StarCalc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStarCalcExport(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TStarCalcExport') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TStarCalcExport') do begin
    RegisterMethod('Constructor Create( Aowner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Execute');
     RegisterMethod('procedure Notification(AComponent: TComponent; Operation: TOperation);');
       RegisterProperty('FileName', 'String', iptrw);
    RegisterProperty('TemplateFileName', 'String', iptrw);
    RegisterProperty('Dataset', 'TDataset', iptrw);
    RegisterProperty('Column', 'Byte', iptrw);
    RegisterProperty('Row', 'Word', iptrw);
    RegisterProperty('CloseStarCalc', 'Boolean', iptrw);
    RegisterProperty('ExcludeFields', 'TStrings', iptrw);
    RegisterProperty('IncludeFields', 'TStrings', iptrw);
    RegisterProperty('IncludeFieldnames', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StarCalc(CL: TPSPascalCompiler);
begin
  SIRegister_TStarCalcExport(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStarCalc');
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStarCalcExportIncludeFieldnames_W(Self: TStarCalcExport; const T: boolean);
begin Self.IncludeFieldnames := T; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportIncludeFieldnames_R(Self: TStarCalcExport; var T: boolean);
begin T := Self.IncludeFieldnames; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportIncludeFields_W(Self: TStarCalcExport; const T: TStrings);
begin Self.IncludeFields := T; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportIncludeFields_R(Self: TStarCalcExport; var T: TStrings);
begin T := Self.IncludeFields; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportExcludeFields_W(Self: TStarCalcExport; const T: TStrings);
begin Self.ExcludeFields := T; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportExcludeFields_R(Self: TStarCalcExport; var T: TStrings);
begin T := Self.ExcludeFields; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportCloseStarCalc_W(Self: TStarCalcExport; const T: Boolean);
begin Self.CloseStarCalc := T; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportCloseStarCalc_R(Self: TStarCalcExport; var T: Boolean);
begin T := Self.CloseStarCalc; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportRow_W(Self: TStarCalcExport; const T: Word);
begin Self.Row := T; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportRow_R(Self: TStarCalcExport; var T: Word);
begin T := Self.Row; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportColumn_W(Self: TStarCalcExport; const T: Byte);
begin Self.Column := T; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportColumn_R(Self: TStarCalcExport; var T: Byte);
begin T := Self.Column; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportDataset_W(Self: TStarCalcExport; const T: TDataset);
begin Self.Dataset := T; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportDataset_R(Self: TStarCalcExport; var T: TDataset);
begin T := Self.Dataset; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportTemplateFileName_W(Self: TStarCalcExport; const T: String);
begin Self.TemplateFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportTemplateFileName_R(Self: TStarCalcExport; var T: String);
begin T := Self.TemplateFileName; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportFileName_W(Self: TStarCalcExport; const T: String);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStarCalcExportFileName_R(Self: TStarCalcExport; var T: String);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StarCalc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStarCalcExport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStarCalcExport) do begin
    RegisterConstructor(@TStarCalcExport.Create, 'Create');
    RegisterMethod(@TStarCalcExport.Execute, 'Execute');
    RegisterMethod(@TStarCalcExport.Destroy, 'Free');
    RegisterMethod(@TStarCalcExport.Notification, 'Notification');
    RegisterPropertyHelper(@TStarCalcExportFileName_R,@TStarCalcExportFileName_W,'FileName');
    RegisterPropertyHelper(@TStarCalcExportTemplateFileName_R,@TStarCalcExportTemplateFileName_W,'TemplateFileName');
    RegisterPropertyHelper(@TStarCalcExportDataset_R,@TStarCalcExportDataset_W,'Dataset');
    RegisterPropertyHelper(@TStarCalcExportColumn_R,@TStarCalcExportColumn_W,'Column');
    RegisterPropertyHelper(@TStarCalcExportRow_R,@TStarCalcExportRow_W,'Row');
    RegisterPropertyHelper(@TStarCalcExportCloseStarCalc_R,@TStarCalcExportCloseStarCalc_W,'CloseStarCalc');
    RegisterPropertyHelper(@TStarCalcExportExcludeFields_R,@TStarCalcExportExcludeFields_W,'ExcludeFields');
    RegisterPropertyHelper(@TStarCalcExportIncludeFields_R,@TStarCalcExportIncludeFields_W,'IncludeFields');
    RegisterPropertyHelper(@TStarCalcExportIncludeFieldnames_R,@TStarCalcExportIncludeFieldnames_W,'IncludeFieldnames');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StarCalc(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStarCalcExport(CL);
  with CL.Add(EStarCalc) do
end;

 
 
{ TPSImport_StarCalc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StarCalc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StarCalc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StarCalc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StarCalc(ri);
  RIRegister_StarCalc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
