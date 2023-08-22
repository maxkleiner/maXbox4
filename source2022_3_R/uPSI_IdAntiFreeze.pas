unit uPSI_IdAntiFreeze;
{
anti for tcp

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
  TPSImport_IdAntiFreeze = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdAntiFreeze(CL: TPSPascalCompiler);
procedure SIRegister_IdAntiFreeze(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdAntiFreeze(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdAntiFreeze(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAntiFreezeBase
  ,IdBaseComponent
  ,IdAntiFreeze
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdAntiFreeze]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdAntiFreeze(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdAntiFreezeBase', 'TIdAntiFreeze') do
  with CL.AddClassN(CL.FindClass('TIdAntiFreezeBase'),'TIdAntiFreeze') do begin
    RegisterMethod('Procedure Process');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdAntiFreeze(CL: TPSPascalCompiler);
begin
  SIRegister_TIdAntiFreeze(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdAntiFreeze(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdAntiFreeze) do begin
    RegisterMethod(@TIdAntiFreeze.Process, 'Process');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdAntiFreeze(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdAntiFreeze(CL);
end;

 
 
{ TPSImport_IdAntiFreeze }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdAntiFreeze.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdAntiFreeze(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdAntiFreeze.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdAntiFreeze(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
