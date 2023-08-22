unit uPSI_JvgExport;
{
  small and simple
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
  TPSImport_JvgExport = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvgExport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvgExport_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //,Messages
  //,Graphics
  //,ExtCtrls
  Controls
  ,Forms
  ,DB
  //,QuickRpt
  //,QRExport
  //,JvgTypes
  ,JvgExport
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvgExport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvgExport(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOnExportProgress', 'Procedure ( Progress : Integer)');
 CL.AddDelphiFunction('Procedure ExportToExcel( QuickRep : TCustomQuickRep)');
 CL.AddDelphiFunction('Procedure ExportDataSetToExcel( DataSet : TDataSet; OnExportProgress : TOnExportProgress)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvgExport_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ExportToExcel, 'ExportToExcel', cdRegister);
 S.RegisterDelphiFunction(@ExportDataSetToExcel, 'ExportDataSetToExcel', cdRegister);
end;

 
 
{ TPSImport_JvgExport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgExport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvgExport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgExport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvgExport(ri);
  RIRegister_JvgExport_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
