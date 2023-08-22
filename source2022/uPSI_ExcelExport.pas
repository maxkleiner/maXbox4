unit uPSI_ExcelExport;
{
   Native Export like 1996!
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
  TPSImport_ExcelExport = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJsExcelExport(CL: TPSPascalCompiler);
procedure SIRegister_ExcelExport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJsExcelExport(CL: TPSRuntimeClassImporter);
procedure RIRegister_ExcelExport(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,DB
  ,DBGrids
  ,ExcelExport
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ExcelExport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsExcelExport(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJsExcelExport') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJsExcelExport') do begin
    RegisterProperty('FBiff8', 'Boolean', iptrw);
    RegisterProperty('FStream', 'TStream', iptrw);
    RegisterMethod('Function ExportTable( ADataSet : TDataSet; AFileName : string) : Boolean');
    RegisterMethod('Function ExportGrid( AGrid : TDBGrid; AFileName : string) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ExcelExport(CL: TPSPascalCompiler);
begin
  SIRegister_TJsExcelExport(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJsExcelExportFStream_W(Self: TJsExcelExport; const T: TStream);
Begin Self.FStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsExcelExportFStream_R(Self: TJsExcelExport; var T: TStream);
Begin T := Self.FStream; end;

(*----------------------------------------------------------------------------*)
procedure TJsExcelExportFBiff8_W(Self: TJsExcelExport; const T: Boolean);
Begin Self.FBiff8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJsExcelExportFBiff8_R(Self: TJsExcelExport; var T: Boolean);
Begin T := Self.FBiff8; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsExcelExport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsExcelExport) do begin
    RegisterPropertyHelper(@TJsExcelExportFBiff8_R,@TJsExcelExportFBiff8_W,'FBiff8');
    RegisterPropertyHelper(@TJsExcelExportFStream_R,@TJsExcelExportFStream_W,'FStream');
    RegisterMethod(@TJsExcelExport.ExportTable, 'ExportTable');
    RegisterMethod(@TJsExcelExport.ExportGrid, 'ExportGrid');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ExcelExport(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJsExcelExport(CL);
end;

 
 
{ TPSImport_ExcelExport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExcelExport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ExcelExport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExcelExport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ExcelExport(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
