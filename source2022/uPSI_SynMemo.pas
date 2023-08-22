unit uPSI_SynMemo;
{
   SYN 
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
  TPSImport_SynMemo = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynMemo(CL: TPSPascalCompiler);
procedure SIRegister_SynMemo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynMemo(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynMemo(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Qt
  ,Types
  ,QSynEdit
  ,QSynEditTextBuffer
  ,QSynEditTypes
  ,RichEdit
  ,Windows
  ,Messages
  ,SynEdit
  ,SynEditTextBuffer
  ,SynEditTypes
  ,SynMemo
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynMemo]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynMemo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynEdit', 'TSynMemo') do
  with CL.AddClassN(CL.FindClass('TSynEdit'),'TSynMemo') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynMemo(CL: TPSPascalCompiler);
begin
  SIRegister_TSynMemo(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynMemo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynMemo) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynMemo(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynMemo(CL);
end;

 
 
{ TPSImport_SynMemo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynMemo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynMemo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynMemo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynMemo(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
