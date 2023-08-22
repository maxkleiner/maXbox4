unit uPSI_JvAddPrinter;
{
   just execute
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
  TPSImport_JvAddPrinter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvAddPrinterDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvAddPrinter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvAddPrinterDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvAddPrinter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,ShlObj
  ,ShellApi
  ,JvBaseDlg
  ,JvAddPrinter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvAddPrinter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAddPrinterDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogF', 'TJvAddPrinterDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvAddPrinterDialog') do begin
   RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterPublishedProperties;
    RegisterMethod('Function Execute : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvAddPrinter(CL: TPSPascalCompiler);
begin
  SIRegister_TJvAddPrinterDialog(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAddPrinterDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAddPrinterDialog) do begin
     RegisterConstructor(@TJvAddPrinterDialog.Create, 'Create');
      RegisterMethod(@TJvAddPrinterDialog.Destroy, 'Free');
     RegisterMethod(@TJvAddPrinterDialog.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAddPrinter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvAddPrinterDialog(CL);
end;

 
 
{ TPSImport_JvAddPrinter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAddPrinter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvAddPrinter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAddPrinter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvAddPrinter(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
