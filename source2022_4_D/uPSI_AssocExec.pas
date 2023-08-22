unit uPSI_AssocExec;
{
   also as function
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
  TPSImport_AssocExec = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAssocExec(CL: TPSPascalCompiler);
procedure SIRegister_AssocExec(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AssocExec_Routines(S: TPSExec);
procedure RIRegister_TAssocExec(CL: TPSRuntimeClassImporter);
procedure RIRegister_AssocExec(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,registry
  ,AssocExec
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AssocExec]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAssocExec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAssocExec') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAssocExec') do
  begin
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('FileName', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AssocExec(CL: TPSPascalCompiler);
begin
  SIRegister_TAssocExec(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAssocExecFileName_W(Self: TAssocExec; const T: String);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TAssocExecFileName_R(Self: TAssocExec; var T: String);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AssocExec_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAssocExec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAssocExec) do
  begin
    RegisterMethod(@TAssocExec.Execute, 'Execute');
    RegisterPropertyHelper(@TAssocExecFileName_R,@TAssocExecFileName_W,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AssocExec(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAssocExec(CL);
end;

 
 
{ TPSImport_AssocExec }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AssocExec.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AssocExec(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AssocExec.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AssocExec(ri);
  RIRegister_AssocExec_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
